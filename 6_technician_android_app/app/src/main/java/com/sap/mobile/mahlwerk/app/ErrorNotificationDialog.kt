package com.sap.mobile.mahlwerk.app

import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import com.sap.mobile.mahlwerk.R

/**
 * This is an activity which is presented as a dialog for presenting error notifications to the user. The notifications
 * can have a short title, a detailed message describing the error and its consequences. Finally, notifications have a
 * so-called fatal flag. It it were true, then the application is killed after the user pressed the OK button.
 */
class ErrorNotificationDialog: Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val startIntent = intent
        val title = startIntent.getStringExtra(TITLE)
        val msg = startIntent.getStringExtra(MSG)
        val isFatal = startIntent.getBooleanExtra(FATAL, false)
        AlertDialog.Builder(this, R.style.AlertDialogStyle)
            .setTitle(title)
            .setMessage(msg)
            .setPositiveButton(R.string.ok, null)
            .setOnDismissListener { onDismissed(isFatal) }
            .show()
    }

    private fun onDismissed(isFatal: Boolean) {
        if (isFatal) {
            val activityManager =
                this@ErrorNotificationDialog.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val tasks = activityManager.appTasks
            for (task in tasks) {
                task.finishAndRemoveTask()
            }
        } else {
            this@ErrorNotificationDialog.finish()
            //disable the disturbing animation when the dialog is dismissed
            this@ErrorNotificationDialog.overridePendingTransition(0,0)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        ErrorPresenterByNotification.errorDialogDismissed()
    }

    companion object {
        val TITLE = "error_title"
        val MSG = "error_msg"
        val FATAL = "isFatal"
    }
}