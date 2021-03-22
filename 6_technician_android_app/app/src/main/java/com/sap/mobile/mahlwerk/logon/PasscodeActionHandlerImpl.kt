package com.sap.mobile.mahlwerk.logon

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.hardware.fingerprint.FingerprintManager
import android.os.Build
import androidx.fragment.app.Fragment
import com.sap.cloud.mobile.foundation.authentication.AppLifecycleCallbackHandler
import com.sap.cloud.mobile.foundation.common.EncryptionError
import com.sap.cloud.mobile.foundation.common.EncryptionState
import com.sap.cloud.mobile.foundation.common.EncryptionUtil
import com.sap.cloud.mobile.foundation.securestore.OpenFailureException
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintActivity
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintSettings
import com.sap.cloud.mobile.onboarding.passcode.*
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.ErrorHandler
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import org.slf4j.LoggerFactory
import java.util.*
import java.util.concurrent.Executors

class PasscodeActionHandlerImpl : PasscodeActionHandler {

    @Throws(PasscodeValidationException::class)
    override fun shouldTryPasscode(
        passcode: CharArray,
        mode: PasscodeInputMode,
        fragment: Fragment
    ) {
        var isSettingFingerprint = false
        val sapWizardApplication = getSAPWizardApplication(fragment)
        val secureStoreManager = sapWizardApplication.secureStoreManager
        val errorHandler = sapWizardApplication.errorHandler
        val clientPolicyManager = sapWizardApplication.clientPolicyManager
        when (mode) {
            PasscodeInputMode.CREATE -> {
                // change from default to user pc
                try {
                    EncryptionUtil.enablePasscode(
                        SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS,
                        passcode
                    )
                    secureStoreManager.openApplicationStore(
                        Arrays.copyOf(passcode, passcode.size)
                    )
                    updatePasscodeTimestamp(secureStoreManager)

                    sapWizardApplication.isOnboarded = true
                    if (clientPolicyManager.getClientPolicy(false).passcodePolicy!!.allowsFingerprint()) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val fingerprintManager = fragment.activity!!.getSystemService(
                                FingerprintManager::class.java
                            )
                            if (fingerprintManager != null && fingerprintManager.isHardwareDetected && fingerprintManager.hasEnrolledFingerprints()) {
                                if (secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_ONLY) {
                                    val intent =
                                        Intent(fragment.activity, FingerprintActivity::class.java)
                                    val fingerprintSettings = FingerprintSettings()
                                    fingerprintSettings.fallbackButtonTitle =
                                            sapWizardApplication.resources.getString(R.string.skip_fingerprint)
                                    fingerprintSettings.isFallbackButtonEnabled = true
                                    fingerprintSettings.saveToIntent(intent)
                                    FingerprintActionHandlerImpl.setPasscode(passcode)
                                    fragment.activity!!.startActivity(intent)
                                    isSettingFingerprint = true
                                }
                            }
                        }
                    }
                    if (!isSettingFingerprint) {
                        clearPasscode(passcode)
                    }
                } catch (e: EncryptionError) {
                    invalidPasscodeCreate(sapWizardApplication, errorHandler)
                } catch (e: OpenFailureException) {
                    invalidPasscodeCreate(sapWizardApplication, errorHandler)
                }
            }
            PasscodeInputMode.CHANGE -> {
                try {
                    EncryptionUtil.changePasscode(
                        SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS,
                        oldPasscode!!,
                        passcode
                    )
                    updatePasscodeTimestamp(secureStoreManager)
                } catch (e: EncryptionError) {
                    val res = sapWizardApplication.resources
                    val errorMessage = ErrorMessage(
                        res.getString(R.string.passcode_change_error),
                        res.getString(R.string.passcode_change_error_detail)
                    )
                    errorHandler.sendErrorMessage(errorMessage)
                    throw PasscodeValidationException("Invalid Passcode", e)
                } finally {
                    clearPasscode(oldPasscode)
                    oldPasscode = null
                }
                if (clientPolicyManager.getClientPolicy(false).passcodePolicy!!.allowsFingerprint()) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val fingerprintManager = fragment.activity!!.getSystemService(
                            FingerprintManager::class.java
                        )
                        if (fingerprintManager != null && fingerprintManager.isHardwareDetected && fingerprintManager.hasEnrolledFingerprints()) {
                            if (secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_ONLY || secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_BIOMETRIC) {
                                val intent =
                                    Intent(fragment.activity, FingerprintActivity::class.java)
                                val fingerprintSettings = FingerprintSettings()
                                fingerprintSettings.fallbackButtonTitle =
                                        sapWizardApplication.resources.getString(R.string.skip_fingerprint)
                                fingerprintSettings.isFallbackButtonEnabled = true
                                fingerprintSettings.saveToIntent(intent)
                                FingerprintActionHandlerImpl.setDisableOnCancel(true)
                                FingerprintActionHandlerImpl.setPasscode(passcode)
                                fragment.activity!!.startActivity(intent)
                                isSettingFingerprint = true
                            }
                        }
                    }
                }
                if (!isSettingFingerprint) {
                    clearPasscode(passcode)
                }
            }
            PasscodeInputMode.MATCH -> {
                matchPasscode(
                    clientPolicyManager,
                    secureStoreManager,
                    sapWizardApplication,
                    passcode
                )
                val executorService = Executors.newSingleThreadExecutor()
                executorService.submit {
                    val clientPolicy = clientPolicyManager.getClientPolicy(true)
                    val passcodePolicy = clientPolicy.passcodePolicy
                    val isLogPolicyEnabled = clientPolicy.isLogEnabled!!
                    // Initialize logging
                    clientPolicyManager.initializeLoggingWithPolicy(isLogPolicyEnabled)
                    if (!passcodePolicy!!.allowsFingerprint() && secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_BIOMETRIC) {
                        // Policy no longer allows fingerprint, but fingerprint is currently enabled.
                        try {
                            EncryptionUtil.disableBiometric(
                                SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS,
                                passcode
                            )
                        } catch (encryptionError: EncryptionError) {
                            LOGGER.error(
                                "Encryption error disabling fingerprint when passcode was already found to be valid.",
                                encryptionError
                            )
                        }

                    }
                    if (!passcodePolicy.validate(passcode) || secureStoreManager.isPasscodeExpired) {
                        if ( !(alertDialog != null && alertDialog!!.isShowing) ) {
                            oldPasscode = passcode
                            AppLifecycleCallbackHandler.getInstance().activity!!.runOnUiThread {
                                val activity = AppLifecycleCallbackHandler.getInstance().activity
                                val alertBuilder =
                                    AlertDialog.Builder(activity, R.style.AlertDialogStyle)
                                alertBuilder.setTitle(activity!!.getString(R.string.new_passcode_required))
                                alertBuilder.setMessage(activity.getString(R.string.new_passcode_required_detail))
                                alertBuilder.setPositiveButton(activity.getString(R.string.ok), null)
                                alertBuilder.setOnDismissListener {
                                    if( AppLifecycleCallbackHandler.getInstance().activity !is SetPasscodeActivity ) {
                                        val intent = Intent(activity, SetPasscodeActivity::class.java)
                                        val setPasscodeSettings = SetPasscodeSettings()
                                        setPasscodeSettings.isChangePasscode = true
                                        setPasscodeSettings.saveToIntent(intent)
                                        activity.startActivity(intent)
                                    }
                                }
                                alertDialog = alertBuilder.create()
                                alertDialog?.show()
                            }
                        }
                    } else {
                        clearPasscode(passcode)
                    }
                }
                executorService.shutdown()
            }
            PasscodeInputMode.MATCHFORCHANGE -> {
                matchPasscode(
                    clientPolicyManager,
                    secureStoreManager,
                    sapWizardApplication,
                    passcode
                )
                oldPasscode = passcode
            }
            else -> {
                clearPasscode(passcode)
                throw Error("Unknown input mode")
            }
        }
    }

    private fun invalidPasscodeCreate(mahlwerkApplication: MahlwerkApplication, errorHandler: ErrorHandler) {
        val res = mahlwerkApplication.resources
        val errorTitle = res.getString(R.string.invalid_passcode)
        val errorDetails = res.getString(R.string.invalid_passcode_detail)
        val errorMessage = ErrorMessage(errorTitle, errorDetails)
        errorHandler.sendErrorMessage(errorMessage)
    }

    private fun clearPasscode(passcode: CharArray?) {
        if (passcode != null) {
            Arrays.fill(passcode, ' ')
        }
    }

    private fun updatePasscodeTimestamp(secureStoreManager: SecureStoreManager) {
        secureStoreManager.doWithPasscodePolicyStore { passcodePolicyStore ->
            passcodePolicyStore.put(ClientPolicyManager.KEY_PC_WAS_SET_AT, Calendar.getInstance())
        }
    }

    @Throws(PasscodeValidationFailedToMatchException::class)
    private fun matchPasscode(
        clientPolicyManager: ClientPolicyManager,
        secureStoreManager: SecureStoreManager,
        context: Context,
        passcode: CharArray
    ) {
        var currentRetryCount =
            secureStoreManager.getWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.getInt(ClientPolicyManager.KEY_RETRY_COUNT)
            }!!
        val retryLimit = clientPolicyManager.getClientPolicy(false).passcodePolicy!!.retryLimit
        try {
            secureStoreManager.reOpenApplicationStoreWithPasscode(
                Arrays.copyOf(
                    passcode,
                    passcode.size
                )
            )
        } catch (e: EncryptionError) {
            currentRetryCount++
            failedToMatch(currentRetryCount, retryLimit, secureStoreManager, context, e)
        } catch (e: OpenFailureException) {
            currentRetryCount++
            failedToMatch(currentRetryCount, retryLimit, secureStoreManager, context, e)
        }
    }

    private fun failedToMatch(currentRetryCount: Int, retryLimit: Int, secureStoreManager: SecureStoreManager, context: Context, exception: Exception) {
        val remaining = retryLimit - currentRetryCount
        secureStoreManager.doWithPasscodePolicyStore { passcodePolicyStore ->
            passcodePolicyStore.put(ClientPolicyManager.KEY_RETRY_COUNT, currentRetryCount)
        }
        val res = context.resources
        throw PasscodeValidationFailedToMatchException(
            res.getString(R.string.invalid_passcode),
            remaining,
            exception
        )
    }

    override fun shouldResetPasscode(fragment: Fragment) {
        val sapWizardApplication = getSAPWizardApplication(fragment)
        val secureStoreManager = sapWizardApplication.secureStoreManager
        val clientPolicyManager = sapWizardApplication.clientPolicyManager
        val retryLimit = clientPolicyManager.getClientPolicy(false).passcodePolicy!!.retryLimit
        val currentRetryCount =
            secureStoreManager.getWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.getInt(ClientPolicyManager.KEY_RETRY_COUNT)
            }!!
        val activity = AppLifecycleCallbackHandler.getInstance().activity

        if (activity == null) {
            LOGGER.error("Couldn't reset because no activity was available!")
            return
        }
        if (retryLimit <= currentRetryCount) {
            sapWizardApplication.resetApplication(activity)
        } else {
            activity.runOnUiThread { sapWizardApplication.resetApplicationWithUserConfirmation() }
        }
    }

    override fun didSkipPasscodeSetup(fragment: Fragment) {
        LOGGER.info("didSkipPasscodeSetup")
        val sapWizardApplication = getSAPWizardApplication(fragment)
        val secureStoreManager = sapWizardApplication.secureStoreManager

        if (secureStoreManager.isUserPasscodeSet) {
            if (oldPasscode != null) {
                try {
                    EncryptionUtil.disablePasscode(
                        SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS,
                        oldPasscode!!
                    )
                } catch (e: EncryptionError) {
                    val res = fragment.activity!!.resources
                    val errorMessage = ErrorMessage(
                        res.getString(R.string.passcode_change_error),
                        res.getString(R.string.passcode_change_error_detail_default)
                    )
                    sapWizardApplication.errorHandler.sendErrorMessage(errorMessage)
                } finally {
                    clearPasscode(oldPasscode)
                    oldPasscode = null
                }
            } else {
                LOGGER.error("Tried to skip the passcode when it was already set!")
            }
        } else {
            try {
                secureStoreManager.openApplicationStore()
            } catch (e: EncryptionError) {
                LOGGER.error(
                    "Store already existed with non-default key when trying to skip passcode!",
                    e
                )
            } catch (e: OpenFailureException) {
                LOGGER.error(
                    "Store already existed with non-default key when trying to skip passcode!",
                    e
                )
            }

        }
        finish(fragment)
    }

    private fun finish(fragment: Fragment) {
        getSAPWizardApplication(fragment).isOnboarded = true
        val intent = Intent()
        val activity = fragment.activity?:return
        activity.setResult(Activity.RESULT_OK, intent)
        activity.finish()
    }

    /**
     * Starts retrieving the passcode policy.
     *
     * @param [fragment] the enclosing fragment invoking this handler, must be non-null
     * @return the passcode policy
     */
    override fun getPasscodePolicy(fragment: Fragment): PasscodePolicy? {
        val clientPolicyManager = getSAPWizardApplication(fragment).clientPolicyManager
        LOGGER.debug("Get PasscodePolicy")
        // The policy should have been refreshed by UnlockActivity.  Only force a refresh here if it
        // is null.
        var passcodePolicy = clientPolicyManager.getClientPolicy(false).passcodePolicy
        if (passcodePolicy == null) {
            passcodePolicy = clientPolicyManager.getClientPolicy(true).passcodePolicy
        }
        return passcodePolicy
    }

    private fun getSAPWizardApplication(fragment: Fragment): MahlwerkApplication {
        return fragment.activity!!.application as MahlwerkApplication
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(PasscodeActionHandlerImpl::class.java)
        private var alertDialog: AlertDialog? = null
        private var oldPasscode: CharArray? = null
    }
}