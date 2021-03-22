package com.sap.mobile.mahlwerk.app

import android.app.Dialog
import android.os.Bundle
import android.view.ContextThemeWrapper
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity
import com.sap.mobile.mahlwerk.R
import org.slf4j.LoggerFactory

class ResetApplicationActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ResetApplicationDialogFragment().run {
            this.isCancelable = false
            this.show(supportFragmentManager, "RESET_APPLICATION_TAG")
        }
    }

    /**
     * Represents the confirmation dialog fragment to reset the application.
     */
    internal class ResetApplicationDialogFragment : DialogFragment() {
        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            if (activity != null) {
                val fragmentActivity = activity as FragmentActivity
                val builder = AlertDialog.Builder(ContextThemeWrapper(fragmentActivity, R.style.AlertDialogStyle))
                builder.setMessage(R.string.reset_app_confirmation)
                        // Setting OK Button
                        .setPositiveButton(R.string.yes) { _, _ ->
                            // reset the application
                            (fragmentActivity.application as MahlwerkApplication).resetApplication(activity!!)
                            LOGGER.info("Yes button is clicked. The all information related to this application will be deleted.")
                            activity!!.finish()
                        }
                        // Setting Cancel Button
                        .setNegativeButton(R.string.cancel) { _, _ ->
                            LOGGER.info("The Cancel button is clicked.")
                            activity!!.finish()
                        }
                return builder.create()
            } else {
                throw IllegalStateException("Activity cannot be null")
            }
        }
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(ResetApplicationActivity::class.java)
    }
}
