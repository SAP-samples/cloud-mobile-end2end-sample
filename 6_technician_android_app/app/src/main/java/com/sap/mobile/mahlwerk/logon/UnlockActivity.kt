package com.sap.mobile.mahlwerk.logon

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.sap.cloud.mobile.foundation.common.EncryptionState
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintActivity
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintErrorSettings
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintSettings
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeActivity
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeSettings
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.MahlwerkApplication

class UnlockActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Can't refresh the policy from the server yet because the store is locked, and necessary
        // credentials could be in the store.
        val sapWizardApplication = (application as MahlwerkApplication)
        val clientPolicyManager = sapWizardApplication.clientPolicyManager
        val secureStoreManager = sapWizardApplication.secureStoreManager
        val passcodePolicy = clientPolicyManager.getClientPolicy(false).passcodePolicy
        if (passcodePolicy!!.allowsFingerprint() && secureStoreManager
                .applicationStoreState == EncryptionState.PASSCODE_BIOMETRIC
        ) {
            unlockWithFingerprint()
        } else {
            unlockWithPasscode()
        }
    }

    private fun unlockWithPasscode() {
        val sapWizardApplication = (application as MahlwerkApplication)
        val secureStoreManager = sapWizardApplication.secureStoreManager
        if (!secureStoreManager.isApplicationStoreOpen) {
            // if retry limit is reached, then EnterPasscode screen is opened in disabled mode, i.e. only reset is possible
            val currentRetryCount =
                secureStoreManager.getWithPasscodePolicyStore { passcodePolicyStore ->
                    passcodePolicyStore.getInt(ClientPolicyManager.KEY_RETRY_COUNT)
                }!!
            val retryLimit =
                sapWizardApplication.clientPolicyManager.getClientPolicy(false).passcodePolicy!!.retryLimit
            val enterPasscodeIntent = Intent(this, EnterPasscodeActivity::class.java)
            val enterPasscodeSettings = EnterPasscodeSettings()
            if (retryLimit <= currentRetryCount) {
                // only reset is allowed
                enterPasscodeSettings.isFinalDisabled = true
            } else {
                enterPasscodeSettings.maxAttemptsReachedMessage =
                        getString(R.string.max_retries_title)
                enterPasscodeSettings.enterCredentialsMessage =
                        getString(R.string.max_retries_message)
                enterPasscodeSettings.isResetEnabled = true
                enterPasscodeSettings.okButtonString = this.getString(R.string.reset_app)
                enterPasscodeSettings.resetButtonText = this.getString(R.string.reset_app)
            }
            enterPasscodeSettings.saveToIntent(enterPasscodeIntent)
            startActivityForResult(enterPasscodeIntent, PASSCODE_UNLOCK)
        }
    }

    private fun unlockWithFingerprint() {
        val secureStoreManager = (application as MahlwerkApplication).secureStoreManager
        if (!secureStoreManager.isApplicationStoreOpen) {
            val intent = Intent(this, FingerprintActivity::class.java)
            val fingerprintSettings = FingerprintSettings()
            fingerprintSettings.fallbackButtonTitle = getString(R.string.use_passcode)
            fingerprintSettings.isFallbackButtonEnabled = true
            fingerprintSettings.saveToIntent(intent)
            val fingerprintErrorSettings = FingerprintErrorSettings()
            fingerprintErrorSettings.isFingerprintErrorResetEnabled = true
            fingerprintErrorSettings.fingerprintErrorResetButtonTitle = getString(R.string.use_passcode)
            fingerprintErrorSettings.saveToIntent(intent)
            this.startActivityForResult(intent, FINGERPRINT_UNLOCK)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == FINGERPRINT_UNLOCK && resultCode == RESULT_CANCELED) {
            unlockWithPasscode()
        } else if (resultCode == RESULT_CANCELED) {
            setResult(RESULT_CANCELED)
            finish()
        } else {
            setResult(RESULT_OK)
            finish()
        }
    }

    companion object {
        private const val PASSCODE_UNLOCK = 1
        private const val FINGERPRINT_UNLOCK = 2
    }
}
