package com.sap.mobile.mahlwerk.logon

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import androidx.fragment.app.Fragment
import com.sap.cloud.mobile.foundation.authentication.AppLifecycleCallbackHandler
import com.sap.cloud.mobile.foundation.common.EncryptionError
import com.sap.cloud.mobile.foundation.common.EncryptionState
import com.sap.cloud.mobile.foundation.common.EncryptionUtil
import com.sap.cloud.mobile.foundation.securestore.OpenFailureException
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintActionHandler
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeActivity
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeSettings
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import org.slf4j.LoggerFactory
import java.util.*
import java.util.concurrent.Executors
import javax.crypto.Cipher

/**
 * Handles the callbacks from [com.sap.cloud.mobile.onboarding.fingerprint.FingerprintActivity]
 * to allow the user to user their fingerprint to unlock the app.
 */
class FingerprintActionHandlerImpl : FingerprintActionHandler {

    /**
     * Provides the cipher that will be authenticated by the user.
     * @param [fragment] The active UI Fragment.
     * @return The cipher that will be authenticated by the user.
     */
    override fun getCipher(fragment: Fragment): Cipher? {
        try {
            return EncryptionUtil.getCipher(SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS)
        } catch (e: EncryptionError) {
            LOGGER.error("EncryptionError getting cipher from EncryptionUtil.", e)
            return null
        }

    }

    /**
     * Receives the cipher after it has been authenticated by the user.  If fingerprint is not
     * currently enabled, this method will enable it.  Otherwise this method unlocks the secure
     * store with the cipher.  After the store is unlocked the server is queried for the passcode
     * policy to make sure using fingerprint is still allowed.
     * @param [fragment] The active UI Fragment.
     * @param [cipher] The cipher that has been authenticated by the user.
     */
    override fun startDone(fragment: Fragment, cipher: Cipher) {
        try {
            val secureStoreManager = getSecureStoreManager(fragment)
            if (secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_BIOMETRIC) {
                secureStoreManager.openApplicationStore(cipher)
                checkPolicyStillAllowsFingerprint(
                    secureStoreManager,
                    getClientPolicyUtilities(fragment)
                )
            } else {
                EncryptionUtil.enableBiometric(
                    SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS,
                    passcode!!,
                    cipher
                )
            }
        } catch (e: EncryptionError) {
            LOGGER.error("Error enabling fingerprint.", e)
        } catch (e: OpenFailureException) {
            LOGGER.error("Error enabling fingerprint.", e)
        } finally {
            clearPasscode()
        }
        val activity = fragment.activity
        if (activity != null) {
            activity.setResult(Activity.RESULT_OK)
            activity.finish()
        }
    }

    /**
     * This method should be invoked when the user presses the fallback button.  Depending on the
     * app state this method may disable fingerprint.
     * @param [fragment] The active UI Fragment.
     */
    override fun fallback(fragment: Fragment) {
        val secureStoreManager = getSecureStoreManager(fragment)
        try {
            if (disableOnCancel) {
                try {
                    if (secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_BIOMETRIC) {
                        EncryptionUtil.disableBiometric(
                            SecureStoreManager.APP_SECURE_STORE_PCODE_ALIAS,
                            passcode!!
                        )
                    }
                    setDisableOnCancel(false)
                } catch (e: EncryptionError) {
                    LOGGER.error("Exception while disabling fingerprint.", e)
                }

            }
        } finally {
            clearPasscode()
        }
        val activity = fragment.activity
        if (activity != null) {
            activity.setResult(Activity.RESULT_CANCELED)
            activity.finish()
        }
    }

    /**
     * This method is called when the user failed to authenticate with fingerprint too many times.
     * This method simply delegates to [FingerprintActionHandlerImpl.fallback].
     * @param [fragment] The active UI Fragment.
     */
    override fun shouldResetPasscode(fragment: Fragment) {
        // Don't want to reset if the user can't enter fingerprint, just do the fallback.
        fallback(fragment)
    }

    /**
     * This method gets the passcode policy from the server to make sure using fingerprint is still
     * allowed.
     */
    private fun checkPolicyStillAllowsFingerprint(
        secureStoreManager: SecureStoreManager,
        clientPolicyManager: ClientPolicyManager
    ) {
        val executorService = Executors.newSingleThreadExecutor()
        executorService.submit {
            val passcodePolicy = clientPolicyManager.getClientPolicy(true)
                .passcodePolicy
            if (!passcodePolicy!!.allowsFingerprint()) {
                policyDisabledFingerprint(secureStoreManager)
            }
        }
        executorService.shutdown()
    }

    /**
     * This method handles the case when the policy has changed so that fingerprint is no longer
     * allowed.  We have to get the user to enter their passcode to disable fingerprint (the
     * passcode member variable only gets set when fingerprint is being enabled, not when
     * unlocking).
     */
    private fun policyDisabledFingerprint(secureStoreManager: SecureStoreManager) {
        if (secureStoreManager.applicationStoreState == EncryptionState.PASSCODE_BIOMETRIC) {
            val activity = AppLifecycleCallbackHandler.getInstance().activity
            if (activity == null) {
                LOGGER.error("Activity not available when required to disable fingerprint.")
                return
            }
            activity.runOnUiThread {
                val alertBuilder = AlertDialog.Builder(activity, R.style.AlertDialogStyle)
                alertBuilder.setTitle(activity.getString(R.string.policy_changed))
                alertBuilder.setMessage(activity.getString(R.string.fingerprint_no_longer_allowed))
                alertBuilder.setPositiveButton(activity.getString(R.string.ok), null)
                alertBuilder.setOnDismissListener {
                    val intent = Intent(activity, EnterPasscodeActivity::class.java)
                    val enterPasscodeSettings = EnterPasscodeSettings()
                    enterPasscodeSettings.maxAttemptsReachedMessage =
                            activity.getString(R.string.max_retries_title)
                    enterPasscodeSettings.enterCredentialsMessage =
                            activity.getString(R.string.max_retries_message)
                    enterPasscodeSettings.isResetEnabled = true
                    enterPasscodeSettings.saveToIntent(intent)
                    activity.startActivity(intent)
                }
                alertBuilder.create().show()
            }
        }
    }

    private fun getSecureStoreManager(fragment: Fragment): SecureStoreManager {
        return (fragment.activity!!.application as MahlwerkApplication).secureStoreManager
    }

    private fun getClientPolicyUtilities(fragment: Fragment): ClientPolicyManager {
        return (fragment.activity!!.application as MahlwerkApplication).clientPolicyManager
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(FingerprintActionHandlerImpl::class.java)
        // The user's passcode.  This array is cleared as soon as the passcode is no longer needed.
        private var passcode: CharArray? = null
        // Tracks the application state so that appropriate action is taken if the user cancels the
        // fingerprint screen.
        private var disableOnCancel = false

        /**
         * This method dictates how a cancellation on the fingerprint screen is handled.
         * @param shouldDisableOnCancel true indicates if the fingerprint screen is cancelled
         * fingerprint should be disabled.
         */
        fun setDisableOnCancel(shouldDisableOnCancel: Boolean) {
            disableOnCancel = shouldDisableOnCancel
        }

        /**
         * This method receives the passcode, which is required when enabling fingerprint.  The array
         * containing the passcode is cleared as soon as it is no longer needed.
         * @param passcode The user's passcode.
         */
        fun setPasscode(passcode: CharArray) {
            FingerprintActionHandlerImpl.passcode = passcode
        }

        /**
         * Helper to clear the passcode.
         */
        private fun clearPasscode() {
            if (passcode != null) {
                Arrays.fill(passcode!!, ' ')
                passcode = null
            }
        }
    }
}
