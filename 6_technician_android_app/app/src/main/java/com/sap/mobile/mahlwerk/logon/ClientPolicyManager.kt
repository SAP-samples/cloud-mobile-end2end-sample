package com.sap.mobile.mahlwerk.logon

import android.widget.Toast
import ch.qos.logback.classic.Level
import com.sap.cloud.mobile.foundation.authentication.AppLifecycleCallbackHandler
import com.sap.cloud.mobile.foundation.common.ClientProvider
import com.sap.cloud.mobile.foundation.logging.Logging
import com.sap.cloud.mobile.foundation.settings.Settings
import com.sap.cloud.mobile.onboarding.passcode.PasscodePolicy
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import org.json.JSONObject
import org.slf4j.LoggerFactory
import java.util.*
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors

class ClientPolicyManager(private var mahlwerkApplication: MahlwerkApplication) {

    private var secureStoreManager = mahlwerkApplication.secureStoreManager

    private var lastPolicy: ClientPolicy? = null
    private var policyFromServer: ClientPolicy? = null
    private var logLevelChangeListeners: MutableList<LogLevelChangeListener> = mutableListOf()

    /**
     * Gets the client policies, including the passcode policy and the logging policy.
     *
     * When the passed property [forceRefresh] is true, this method will get the policy from the server. If the policy
     * cannot be retrieved from the server, it will be retrieved from a cached policy from a local store. If there is no
     * cached policy, a default policy will be returned. When false, this method will get the cached policy from a local
     * store. If there is no cached policy, a default policy will be returned. No network requests will be sent when
     * this parameter is false.
     *
     * @property [forceRefresh] When [true], policy is requested through the network. Cashed or local policy otherwise.
     *
     * @returns the defualt [ClientPolicy] or one from the server / cache.
     */
    fun getClientPolicy(forceRefresh: Boolean): ClientPolicy {
        var clientPolicy: ClientPolicy?

        if (!forceRefresh) {
            clientPolicy = lastPolicy ?: getClientPolicyFromStore()
            clientPolicy = clientPolicy ?: getDefaultPolicy()
        } else {
            // first try to read it from the server, if not stressful then take the local persisted one,
            // finally, fallback to the default one
            getClientPolicyFromServer()
            clientPolicy = policyFromServer
            if (clientPolicy == null) {
                clientPolicy = getClientPolicyFromStore()
                clientPolicy = clientPolicy ?: getDefaultPolicy()
            } else {
                // store policy and retry count in the passcode policy store
                val policy = clientPolicy
                secureStoreManager.doWithPasscodePolicyStore { passcodePolicyStore ->
                        passcodePolicyStore.put(KEY_CLIENT_POLICY, policy)
                        passcodePolicyStore.put(KEY_RETRY_COUNT, 0)
                }
            }
            lastPolicy = clientPolicy
        }
        return clientPolicy
    }

    private fun getClientPolicyFromServer() {
        policyFromServer = null

        val settingsParameters = mahlwerkApplication.settingsParameters
        if (settingsParameters != null) {
            val downloadLatch = CountDownLatch(1)
            val executor = Executors.newSingleThreadExecutor()

            executor.submit {
                val settings = Settings(ClientProvider.get(), settingsParameters)
                settings.load(
                    Settings.SettingTarget.USER,
                    "mobileservices/settingsExchange",
                    PolicyCallbackListener(downloadLatch)
                )
            }

            executor.shutdown()
            try {
                downloadLatch.await()
            } catch (e: InterruptedException) {
                LOGGER.error("Unexpected interruption during client policy download", e)
                Thread.currentThread().interrupt()
            }
        }
    }

    private fun getDefaultPolicy(): ClientPolicy {
        // There is no default passcode policy, keep the passcode policy null in defClientPolicy.
        return ClientPolicy().apply {
            isLogEnabled = true
            logLevel = Level.INFO
        }
    }

    private fun getClientPolicyFromStore(): ClientPolicy? =
        secureStoreManager.getWithPasscodePolicyStore { passcodePolicyStore ->
            passcodePolicyStore.getSerializable(KEY_CLIENT_POLICY)
        }

    private fun logLevelFromServerString(logLevel: String): Level {
        val lowerCaseLogLevel = logLevel.toLowerCase(Locale.getDefault())
        if (lowerCaseLogLevel.startsWith("warn")) return Level.WARN
        return when (lowerCaseLogLevel) {
            "none" -> Level.OFF
            "fatal" -> Level.ERROR
            "error" -> Level.ERROR
            "info" -> Level.INFO
            "debug" -> Level.DEBUG
            "path" -> Level.ALL
            else -> Level.DEBUG
        }
    }

    private inner class PolicyCallbackListener(private val downloadLatch: CountDownLatch) : Settings.CallbackListener {

        override fun onSuccess(result: JSONObject) {
            val passcodePolicyJson: JSONObject? = result.optJSONObject(SETTINGS_PASSCODE)
            if (passcodePolicyJson != null) {
                policyFromServer = ClientPolicy()
                val isPasscodePolicyEnabled = passcodePolicyJson.optBoolean(PASSCODE_POLICY_ENABLED, true)
                policyFromServer?.isPasscodePolicyEnabled = isPasscodePolicyEnabled

                val passcodePolicy = PasscodePolicy().apply {
                    setAllowsFingerprint(passcodePolicyJson.optBoolean(PASSCODE_POLICY_FINGERPRINT_ENABLED, true))
                    setHasDigit(passcodePolicyJson.optBoolean(PASSCODE_POLICY_DIGIT_REQUIRED, false))
                    setHasLower(passcodePolicyJson.optBoolean(PASSCODE_POLICY_LOWER_REQUIRED, false))
                    setHasSpecial(passcodePolicyJson.optBoolean(PASSCODE_POLICY_SPECIAL_REQUIRED, false))
                    setHasUpper(passcodePolicyJson.optBoolean(PASSCODE_POLICY_UPPER_REQUIRED, false))
                    setIsDigitsOnly(passcodePolicyJson.optBoolean(PASSCODE_POLICY_IS_DIGITS_ONLY, false))
                    minLength = passcodePolicyJson.optInt(PASSCODE_POLICY_MIN_LENGTH, 8)
                    minUniqueChars = passcodePolicyJson.optInt(PASSCODE_POLICY_MIN_UNIQUE_CHARS, 0)
                    retryLimit = passcodePolicyJson.optInt(PASSCODE_POLICY_RETRY_LIMIT, 20)
                    // if policy were enabled, then no default would be allowed
                    isSkipEnabled = false
                }
                policyFromServer?.passcodePolicy = passcodePolicy
                secureStoreManager.passcodeLockTimeout = passcodePolicyJson.optInt(PASSCODE_POLICY_LOCK_TIMEOUT, 300)
                secureStoreManager.passcodeExpirationTimeFrame = passcodePolicyJson.optInt(
                    PASSCODE_POLICY_EXPIRES_IN_N_DAYS, 0)
            }
            val logSettingsJson = result.optJSONObject(SETTINGS_LOG)
            if (logSettingsJson != null) {
                val isLogEnabled = logSettingsJson.optBoolean(LOG_POLICY_LOG_ENABLED, false)
                policyFromServer?.isLogEnabled = isLogEnabled
                if (isLogEnabled) {
                    val logLevelStr = logSettingsJson.optString(LOG_POLICY_LOG_LEVEL, "DEBUG")
                    val logLevel = logLevelFromServerString(logLevelStr)
                    policyFromServer?.logLevel = logLevel
                }
            }
            downloadLatch.countDown()
        }

        override fun onError(throwable: Throwable) {
            policyFromServer = null
            LOGGER.error("Could not download the policy from the server due to error: ${throwable.message}")
            downloadLatch.countDown()
        }
    }

    fun initializeLoggingWithPolicy(isLogPolicyEnabled: Boolean) {
        // Get the log level from the policy
        var logLevel: Level? = getClientPolicy(false).logLevel
        // Get the log level from the Store
        val logLevelStored: Level? = secureStoreManager.getWithPasscodePolicyStore { passcodePolicyStore ->
            passcodePolicyStore.getSerializable(KEY_CLIENT_LOG_LEVEL)
        }
        logLevel = logLevel ?: Level.WARN
        // Compare the previous value to the new value
        if (logLevelStored == null || (isLogPolicyEnabled && logLevel?.levelInt != logLevelStored.levelInt)) {
            val finalLogLevel = logLevel
            secureStoreManager.doWithPasscodePolicyStore { passcodePolicyStore ->
                passcodePolicyStore.put(KEY_CLIENT_LOG_LEVEL, finalLogLevel)
            }

            // Show the new value to the user in a Toast message
            if (isLogPolicyEnabled) {
                AppLifecycleCallbackHandler.getInstance().activity?.runOnUiThread {
                    finalLogLevel?.let { notifyLogLevelChangeListeners(it) }
                    val activity = AppLifecycleCallbackHandler.getInstance().activity
                    Toast.makeText(activity,
                        String.format(activity!!.getString(R.string.log_level_changed), mahlwerkApplication.logUtil.getLevelString(finalLogLevel)),
                        Toast.LENGTH_SHORT).show()
                }
            } else {
                AppLifecycleCallbackHandler.getInstance().activity?.runOnUiThread {
                    val activity = AppLifecycleCallbackHandler.getInstance().activity
                    Toast.makeText(
                        activity,
                        String.format(activity!!.getString(R.string.log_level_default), mahlwerkApplication.logUtil.getLevelString(finalLogLevel)),
                        Toast.LENGTH_SHORT).show()
                }
            }
        }
        // Set the log level
        Logging.getRootLogger().level = logLevel
    }

    fun resetLogLevelChangeListener(){
        logLevelChangeListeners.clear()
    }

    fun setLogLevelChangeListener(logLevelChangeListener: LogLevelChangeListener) {
        logLevelChangeListeners.add(logLevelChangeListener)
    }

    fun removeLogLevelChangeListener(logLevelChangeListener: LogLevelChangeListener) {
        logLevelChangeListeners.remove(logLevelChangeListener)
    }

    interface LogLevelChangeListener {
        fun logLevelChanged(level: Level)
    }

    private fun notifyLogLevelChangeListeners(newLogLevel: Level) {
        for (listener in logLevelChangeListeners) {
            listener.logLevelChanged(newLogLevel)
        }

    }

    companion object {
        const val KEY_RETRY_COUNT = "retryCount"
        const val KEY_PC_WAS_SET_AT = "when_was_the_pc_set"

        private val PASSCODE_POLICY_FINGERPRINT_ENABLED = "passwordPolicyFingerprintEnabled"
        private val PASSCODE_POLICY_DIGIT_REQUIRED = "passwordPolicyDigitRequired"
        private val PASSCODE_POLICY_LOWER_REQUIRED = "passwordPolicyLowerRequired"
        private val PASSCODE_POLICY_SPECIAL_REQUIRED = "passwordPolicySpecialRequired"
        private val PASSCODE_POLICY_UPPER_REQUIRED = "passwordPolicyUpperRequired"
        private val PASSCODE_POLICY_MIN_LENGTH = "passwordPolicyMinLength"
        private val PASSCODE_POLICY_MIN_UNIQUE_CHARS = "passwordPolicyMinUniqueChars"
        private val PASSCODE_POLICY_RETRY_LIMIT = "passwordPolicyRetryLimit"
        private val PASSCODE_POLICY_IS_DIGITS_ONLY = "passwordPolicyIsDigitsOnly"
        private val PASSCODE_POLICY_ENABLED = "passwordPolicyEnabled"
        private val PASSCODE_POLICY_LOCK_TIMEOUT = "passwordPolicyLockTimeout"
        private val PASSCODE_POLICY_EXPIRES_IN_N_DAYS = "passwordPolicyExpiresInNDays"

        private val LOG_POLICY_LOG_LEVEL = "logLevel"
        private val LOG_POLICY_LOG_ENABLED = "logEnabled"

        private val SETTINGS_PASSCODE = "passwordPolicy"
        private val SETTINGS_LOG = "logSettings"

        private val KEY_CLIENT_POLICY = "passcodePolicy"

        const val KEY_CLIENT_LOG_LEVEL = "client_log_level"
        private val LOGGER = LoggerFactory.getLogger(ClientPolicyManager::class.java)
    }
}