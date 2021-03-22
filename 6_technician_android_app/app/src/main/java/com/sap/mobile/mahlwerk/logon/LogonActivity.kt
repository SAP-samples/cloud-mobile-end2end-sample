package com.sap.mobile.mahlwerk.logon

import android.app.AlertDialog
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Bundle
import android.os.IBinder
import android.view.View
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.preference.PreferenceManager
import ch.qos.logback.classic.Level
import com.sap.cloud.mobile.foundation.authentication.AppLifecycleCallbackHandler
import com.sap.cloud.mobile.foundation.common.EncryptionError
import com.sap.cloud.mobile.foundation.logging.Logging
import com.sap.cloud.mobile.foundation.securestore.OpenFailureException
import com.sap.cloud.mobile.odata.core.Action0
import com.sap.cloud.mobile.odata.core.Action1
import com.sap.cloud.mobile.onboarding.launchscreen.LaunchScreenSettings
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeActivity
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeSettings
import com.sap.cloud.mobile.onboarding.passcode.SetPasscodeActivity
import com.sap.cloud.mobile.onboarding.passcode.SetPasscodeSettings
import com.sap.cloud.mobile.onboarding.utility.OnboardingType
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.activity.MainActivity
import com.sap.mobile.mahlwerk.app.ConfigurationData
import com.sap.mobile.mahlwerk.app.ErrorHandler
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import com.sap.mobile.mahlwerk.offline.OfflineODataSyncService
import com.sap.mobile.mahlwerk.service.SAPServiceManager
import org.slf4j.LoggerFactory
import java.util.concurrent.Executors

class LogonActivity: AppCompatActivity() {

    private var isResuming = false
    private var isAwaitingResult = false

    private var sapServiceManager: SAPServiceManager? = null

    private var secureStoreManager: SecureStoreManager? = null

    private var clientPolicyManager: ClientPolicyManager? = null

    private var errorHandler: ErrorHandler? = null

    private var configurationData: ConfigurationData? = null

    /*
     * Android Bound Service to handle offline synchronization operations. Service runs in foreground mode to maximize
     * resiliency.
     */
    private var offlineSyncService: OfflineODataSyncService? = null

    /*
     * Flag to indicate that current activity is bound to the Offline Sync Service
     */
    private var isBound: Boolean = false

    /*
     * Service connection object callbacks when service is bound or lost
     */
    private lateinit var serviceConnection: ServiceConnection

    /*
     * Indicates that initial opening and downloading of offline data store
     */
    private lateinit var initialOpenProgressBar: ProgressBar

    /*
     * Advise user of initial open delay
     */
    private lateinit var initialOpenStatus: TextView

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        isAwaitingResult = false
        LOGGER.debug("PASSCODE_ERROR","Passcode validation "+ resultCode);
        when(requestCode) {
            LAUNCH_SCREEN -> when(resultCode) {
                RESULT_OK -> setPasscode()
                CONTEXT_IGNORE_SECURITY -> finishLogonActivity()
                RESULT_CANCELED -> finish()
                else -> startLaunchScreen()
            }
            SET_PASSCODE -> when(resultCode) {
                RESULT_OK -> finishLogonActivity()
                RESULT_CANCELED -> startLaunchScreen()
                SetPasscodeActivity.POLICY_CANCELLED -> {
                    LOGGER.error("Resetting the app after the passcode policy couldn't be retrieved.")
                    (application as MahlwerkApplication).resetApplication(this)
                }
            }
            ENTER_PASSCODE -> when(resultCode) {
                RESULT_OK -> finishLogonActivity()
                RESULT_CANCELED -> finishAffinity()
            }
            MAIN_ACTIVITY -> {} // TODO check if something should be done here?
            else -> {}
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putBoolean(IS_AWAITING_RESULT_KEY, isAwaitingResult)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        isAwaitingResult = savedInstanceState?.getBoolean(IS_AWAITING_RESULT_KEY)?: false

        sapServiceManager = (application as MahlwerkApplication).sapServiceManager
        secureStoreManager = (application as MahlwerkApplication).secureStoreManager
        clientPolicyManager = (application as MahlwerkApplication).clientPolicyManager
        errorHandler = (application as MahlwerkApplication).errorHandler
        configurationData = (application as MahlwerkApplication).configurationData

        val bundle = intent.extras
        isResuming = bundle?.getBoolean(IS_RESUMING_KEY, false)?: false

        FingerprintActionHandlerImpl.setDisableOnCancel(false)
        setContentView(R.layout.activity_logon)

        if (isAwaitingResult) {
            return
        }

        // Initialize logging
        Logging.initialize(
            applicationContext,
            Logging.ConfigurationBuilder()
                .initialLevel(Level.WARN)
                .logToConsole(true)
                .build()
        )

        val isOnBoarded = (application as MahlwerkApplication).isOnboarded

        if (!isOnBoarded) {
            // create the store for application data (with default passcode)
            try {
                secureStoreManager?.openApplicationStore()
            } catch (e: EncryptionError) {
                LOGGER.error("Unable to open initial application store with default passcode", e)
            } catch(e: OpenFailureException) {
                LOGGER.error("Unable to open initial application store with default passcode", e)
            }
            startLaunchScreen()
        } else {
            // config data must be present
            when(configurationData?.isLoaded) {
                false -> logErrorAndResetApplication(
                    resources.getString(R.string.config_data_error_title),
                    resources.getString(R.string.config_data_corrupted_description)
                )
                else -> {
                    val isUserPasscode = secureStoreManager?.isUserPasscodeSet ?: false
                    when(isUserPasscode) {
                        true -> when(secureStoreManager?.isApplicationStoreOpen) {
                            true -> finishLogonActivity()
                            else -> enterPasscode()
                        }
                        else -> {
                            openApplicationStore()
                            val executorService = Executors.newSingleThreadExecutor()
                            executorService.submit {
                                val clientPolicy = clientPolicyManager?.getClientPolicy(true)
                                val isPolicyEnabled = clientPolicy?.isPasscodePolicyEnabled!!
                                val isLogPolicyEnabled = clientPolicy.isLogEnabled!!
                                clientPolicyManager?.initializeLoggingWithPolicy(isLogPolicyEnabled)
                                secureStoreManager?.isPasscodePolicyEnabled = isPolicyEnabled
                                val isDefaultEnabled = clientPolicyManager?.getClientPolicy(false)?.passcodePolicy?.isSkipEnabled!!
                                if (isPolicyEnabled && !isDefaultEnabled) {
                                    this@LogonActivity.runOnUiThread {
                                        val activity = AppLifecycleCallbackHandler.getInstance().activity
                                        val alertBuilder = AlertDialog.Builder(activity, R.style.AlertDialogStyle)
                                        val res = this@LogonActivity.resources
                                        alertBuilder.setTitle(res.getString(R.string.passcode_required))
                                        alertBuilder.setMessage(res.getString(R.string.passcode_required_detail))
                                        alertBuilder.setPositiveButton(res.getString(R.string.ok), null)
                                        alertBuilder.setOnDismissListener {
                                            val intent = Intent(activity, SetPasscodeActivity::class.java)
                                            val setPasscodeSettings = SetPasscodeSettings()
                                            setPasscodeSettings.saveToIntent(intent)
                                            isAwaitingResult = true
                                            this@LogonActivity.startActivityForResult(intent, SET_PASSCODE)
                                        }
                                    }
                                }
                            }
                            executorService.shutdown()
                            finishLogonActivity()
                        }
                    }
                }
            }
        }
    }

    private fun logErrorAndResetApplication(errorTitle: String, errorDetails: String) {
        errorHandler?.sendErrorMessage(ErrorMessage(errorTitle, errorDetails))
        (application as MahlwerkApplication).resetApplication(this)
    }

    private fun setPasscode() {
        val executorService = Executors.newSingleThreadExecutor()
        executorService.submit {
            val clientPolicy = clientPolicyManager?.getClientPolicy(true)
            val passcodePolicy = clientPolicy?.passcodePolicy
            // isPolicyEnabled defaults to true, because the error message informing the user the
            // passcode policy couldn't be retrieved is shown on the set passcode screen.
            val isPolicyEnabled = if (passcodePolicy != null) clientPolicy.isPasscodePolicyEnabled!! else true
            val isLogPolicyEnabled = clientPolicy?.isLogEnabled!!
            clientPolicyManager?.initializeLoggingWithPolicy(isLogPolicyEnabled)
            secureStoreManager?.isPasscodePolicyEnabled = isPolicyEnabled

            if (isPolicyEnabled) {
                val i = Intent(this@LogonActivity, SetPasscodeActivity::class.java)
                val setPasscodeSettings = SetPasscodeSettings()
                setPasscodeSettings.skipButtonText = getString(R.string.skip_passcode)
                setPasscodeSettings.saveToIntent(i)
                isAwaitingResult = true
                startActivityForResult(i, SET_PASSCODE)
            } else {
                openApplicationStore()
                (application as MahlwerkApplication).isOnboarded = true
                startApplication()
            }
        }
        executorService.shutdown()
    }

    private fun enterPasscode() {
        // if retry limit is reached, then EnterPasscode screen is opened in disabled mode, i.e. only
        // reset is possible
        val currentRetryCount = secureStoreManager?.getWithPasscodePolicyStore { passcodePolicyStore ->
            passcodePolicyStore.getInt(ClientPolicyManager.KEY_RETRY_COUNT)
        }!!
        val retryLimit = clientPolicyManager?.getClientPolicy(false)?.passcodePolicy!!.retryLimit
        if (retryLimit <= currentRetryCount) {
            // only reset is allowed
            val enterPasscodeIntent = Intent(this, EnterPasscodeActivity::class.java)
            val enterPasscodeSettings = EnterPasscodeSettings()
            enterPasscodeSettings.isFinalDisabled = true
            enterPasscodeSettings.saveToIntent(enterPasscodeIntent)
            isAwaitingResult = true
            startActivityForResult(enterPasscodeIntent, ENTER_PASSCODE)
        } else {
            // client policy is refreshed now in UnlockActivity
            val unlockIntent = Intent(this, UnlockActivity::class.java)
            isAwaitingResult = true
            startActivityForResult(unlockIntent, ENTER_PASSCODE)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (isBound) {
            unbindService(serviceConnection)
            offlineSyncService = null
        }
    }

    private fun startLaunchScreen() {
        val welcome = Intent(this, com.sap.cloud.mobile.onboarding.launchscreen.LaunchScreenActivity::class.java)

        LaunchScreenSettings().apply {
            isDemoAvailable = false
            launchScreenHeadline = getString(R.string.welcome_screen_headline_label)
            welcomeScreenType = OnboardingType.STANDARD_ONBOARDING
            launchScreenTitles = arrayOf(getString(R.string.application_name))
            launchScreenImages = intArrayOf(R.drawable.ic_launch_screen)
            launchScreenDescriptions = arrayOf(getString(R.string.welcomeScreen))
            launchScreenPrimaryButton = getString(R.string.welcome_screen_primary_button_label)
        }.saveToIntent(welcome)
        isAwaitingResult = true
        startActivityForResult(welcome, LAUNCH_SCREEN)
    }

    private fun startApplication() {
        openODataStore(Action0 {
            sapServiceManager!!.synchronize(offlineSyncService!!, Action0 {
                startMainActivity()
            }, Action1 {
                // TODO: Error Handling
                startMainActivity()
            })
        } )
    }

    private fun startMainActivity() {
        val intent = Intent(this@LogonActivity, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        startActivityForResult(intent, MAIN_ACTIVITY)
    }

    private fun finishLogonActivity() {
        if (isResuming) {
            LOGGER.debug("finishing LogonActivity since app is resuming.")
            finish()
        } else {
            LOGGER.debug("Starting entity set list activity since app is starting for first time.")
            startApplication()
        }
    }

    private fun openApplicationStore() {
        try {
            secureStoreManager?.openApplicationStore()
        } catch (e: EncryptionError) {
            val errorTitle = resources.getString(R.string.secure_store_error)
            val errorDetails = resources.getString(R.string.secure_store_open_default_error_detail)
            val errorMessage = ErrorMessage(errorTitle, errorDetails, e, false)
            errorHandler?.sendErrorMessage(errorMessage)
        } catch (e: OpenFailureException) {
            val errorTitle = resources.getString(R.string.secure_store_error)
            val errorDetails = resources.getString(R.string.secure_store_open_default_error_detail)
            val errorMessage = ErrorMessage(errorTitle, errorDetails, e, false)
            errorHandler?.sendErrorMessage(errorMessage)
        }
    }

    /**
     * Open offline data store by connection to Offline Sync Service and if successful proceeds with
     * actual open. When bind to service, callbacks will occur on functions in the service connection
     * object for connected and disconnected events.
     * @param openDoneHandler - handler to invoke when offline data store is opened successfully
     */
    private fun openODataStore(openDoneHandler: Action0) {
        serviceConnection = object : ServiceConnection {
            override fun onServiceConnected(className: ComponentName, service: IBinder) {
                offlineSyncService = (service as OfflineODataSyncService.LocalBinder).service
                isBound = true
                open(openDoneHandler)
            }

            override fun onServiceDisconnected(className: ComponentName) {
                offlineSyncService = null
                isBound = false
            }
        }

        if (!bindService(Intent(this, OfflineODataSyncService::class.java), serviceConnection, Context.BIND_AUTO_CREATE)) {
            unbindService(serviceConnection)
            val errorTitle = resources.getString(R.string.bind_error)
            val errorDetails = resources.getString(R.string.bind_error_detail)
            val errorMessage = ErrorMessage(errorTitle, errorDetails, null, false)
            errorHandler!!.sendErrorMessage(errorMessage)
            LOGGER.error("Bind service encountered failure.")
        }
    }

    /**
     * Performs actual open by calling Offline Sync Service.
     * Display progress and text to advise users of lengthy initial open and wait for completion
     * @param openDoneHandler - handle to call when offline data store is opened successfully
     */
    private fun open(openDoneHandler: Action0) {
        val showProgress = checkAndSetupShowProgress()
        offlineSyncService!!.openStore(sapServiceManager!!.retrieveProvider()!!,
            Action0 {
                if (showProgress) {
                    this@LogonActivity.runOnUiThread {
                        initialOpenStatus.visibility = View.INVISIBLE
                        initialOpenProgressBar.visibility = View.INVISIBLE
                    }
                    val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(applicationContext)
                    val editor = sharedPreferences.edit()
                    editor.putBoolean(sharedPreferenceKey, true)
                    editor.commit()
                }
                openDoneHandler.call()
            },
            Action1 { error ->
                if (showProgress) {
                    this@LogonActivity.runOnUiThread {
                        initialOpenStatus.visibility = View.INVISIBLE
                        initialOpenProgressBar.visibility = View.INVISIBLE
                    }
                }
                val errorTitle = resources.getString(R.string.offline_initial_open_error)
                val errorDetails = resources.getString(R.string.offline_initial_open_error_detail)
                val errorMessage = ErrorMessage(errorTitle, errorDetails, error, false)
                errorHandler!!.sendErrorMessage(errorMessage)
            })
    }

    /**
     * Check to see if this is an initial open by looking for a stored flag in shared preferences for this activity
     * @return true if progress and text display should be shown i.e. initial open
     */
    private fun checkAndSetupShowProgress(): Boolean {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)
        val isOfflineStoreInitialized = sharedPreferences.getBoolean(sharedPreferenceKey, false)

        if (!isOfflineStoreInitialized) {
            initialOpenProgressBar = findViewById(R.id.progressbar)
            initialOpenProgressBar.isIndeterminate = true
            initialOpenProgressBar.visibility = View.VISIBLE

            initialOpenStatus = findViewById(R.id.initial_open_text)
            initialOpenStatus.visibility = View.VISIBLE
            initialOpenStatus.text = resources.getString(R.string.initializing_offline_store)
            return true
        }
        return false
    }
    companion object {
        const val IS_RESUMING_KEY = "isResuming"
        val IS_AWAITING_RESULT_KEY = "isAwaitingResult"
        private const val LAUNCH_SCREEN = 100
        private const val SET_PASSCODE = 200
        private const val ENTER_PASSCODE = 300
        private const val sharedPreferenceKey = "OfflineODataStoreInitialized"
        private const val MAIN_ACTIVITY = 500

        private val LOGGER = LoggerFactory.getLogger(LogonActivity::class.java)
    }
}
