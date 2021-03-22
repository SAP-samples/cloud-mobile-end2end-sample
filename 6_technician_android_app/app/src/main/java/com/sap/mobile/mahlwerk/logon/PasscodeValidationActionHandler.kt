package com.sap.mobile.mahlwerk.logon;

import androidx.fragment.app.Fragment
import com.sap.cloud.mobile.onboarding.passcode.PasscodeValidationActionHandler
import com.sap.cloud.mobile.onboarding.passcode.PasscodeValidationException

class PasscodeValidationActionHandler: PasscodeValidationActionHandler {

    @Throws(PasscodeValidationException::class, InterruptedException::class)
    override fun validate(fragment: Fragment, chars: CharArray) {
        // You can extend the validator with your own policy.
    }
}