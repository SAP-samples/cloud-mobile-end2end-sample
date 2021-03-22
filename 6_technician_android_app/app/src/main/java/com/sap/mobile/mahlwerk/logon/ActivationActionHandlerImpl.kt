package com.sap.mobile.mahlwerk.logon

import android.app.Activity
import android.content.Intent
import androidx.fragment.app.Fragment
import com.sap.cloud.mobile.onboarding.activation.ActivationActionHandler

class ActivationActionHandlerImpl: ActivationActionHandler {

    override fun startOnboardingWithDiscoveryServiceEmail(fragment: Fragment?, userEmail: String?) {
        val intent = Intent()
        intent.putExtra(DISCOVERY_SVC_EMAIL, userEmail)
        fragment?.activity?.setResult(Activity.RESULT_OK, intent)
        fragment?.activity?.finish()
    }

    companion object {
        val DISCOVERY_SVC_EMAIL = "eMailAddress"
    }
}