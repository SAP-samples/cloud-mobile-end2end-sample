package com.sap.mobile.mahlwerk.app

import android.content.Intent
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import com.sap.cloud.mobile.foundation.authentication.AppLifecycleCallbackHandler
import com.sap.cloud.mobile.onboarding.fingerprint.FingerprintActivity
import com.sap.cloud.mobile.onboarding.passcode.EnterPasscodeActivity
import com.sap.mobile.mahlwerk.logon.LogonActivity
import com.sap.mobile.mahlwerk.logon.SecureStoreManager
import java.util.*

/**
 * Class for handling application lifecycle events.
 */
class LifecycleObserver(private val secureStoreManager: SecureStoreManager) :
    DefaultLifecycleObserver {

    private var timer: Timer? = null
    private val lock = Any()

    /**
     * Method checks if the app is in background or not
     */
    val isAppInBackground: Boolean
        get() {
            val currentState = ProcessLifecycleOwner.get().lifecycle.currentState
            return !currentState.isAtLeast(Lifecycle.State.RESUMED)
        }

    init {
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    override fun onResume(owner: LifecycleOwner) {
        synchronized(lock) {
            if (timer != null) {
                timer!!.cancel()
                timer = null
            }
            if (!secureStoreManager.isApplicationStoreOpen) {
                val activity = AppLifecycleCallbackHandler.getInstance().activity
                if (activity!!.javaClass != LogonActivity::class.java &&
                        activity.javaClass != EnterPasscodeActivity::class.java &&
                        activity.javaClass != FingerprintActivity::class.java) {
                    val startIntent = Intent(activity, LogonActivity::class.java)
                    startIntent.putExtra(LogonActivity.IS_RESUMING_KEY, true)
                    activity.startActivity(startIntent)
                }
            }
        }
    }

    override fun onPause(owner: LifecycleOwner) {
        synchronized(lock) {
            if (timer == null) {
                val timeOut = secureStoreManager.passcodeLockTimeout
                val isUserPasscodeSet = secureStoreManager.isUserPasscodeSet
                if (timeOut >= 0 && isUserPasscodeSet) {
                    timer = Timer()
                    timer!!.schedule(object : TimerTask() {
                        override fun run() {
                            secureStoreManager.closeApplicationStore()
                        }
                    }, (timeOut * 1000).toLong())
                }
            }
        }
    }
}
