package com.sap.mobile.mahlwerk.model

import android.content.Context
import com.sap.mobile.mahlwerk.R

/**
 * Represents the status of a final report as an enum for convenience
 */
enum class FinalReportStatus(private val resourceId: Int) {
    NotSent(R.string.status_notSent),
    Sent(R.string.status_sent),
    Approved(R.string.status_approved);

    /**
     * Returns the localized string for the status
     *
     * @return the localized string
     */
    fun getLocalizedString(context: Context): String {
        return context.getString(resourceId)
    }
}