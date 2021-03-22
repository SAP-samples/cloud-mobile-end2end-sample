package com.sap.mobile.mahlwerk.model

import android.content.Context
import com.sap.mobile.mahlwerk.R

/**
 * Represents the status of a job as an enum for convenience
 */
enum class JobStatus(private val stringId: Int, private val colorId: Int) {
    Open(R.string.status_open, R.color.status_open),
    Done(R.string.status_done, R.color.status_done);

    /** Convenience property to get the next status of a job */
    val nextStatus: JobStatus
        get() = when (this) {
            Open -> Done
            Done -> throw AssertionError("Status 'Done' has no next status")
        }

    /** Convenience property to get the next statusID of a job */
    val nextStatusID: Long
        get() = nextStatus.ordinal.toLong()

    /**
     * Returns the localized string for the status
     *
     * @return the localized string
     */
    fun getLocalizedString(context: Context): String {
        return context.getString(stringId)
    }

    /**
     * Returns the color for the status
     *
     * @return the color of the status
     */
    fun getColor(context: Context): Int {
        return context.getColor(colorId)
    }
}