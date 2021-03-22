package com.sap.mobile.mahlwerk.model

import android.content.Context
import com.sap.mobile.mahlwerk.R

/**
 * Represents the status of a task as an enum for convenience
 */
enum class TaskStatus(private val stringId: Int, private val colorId: Int) {
    Open(R.string.open, R.color.status_open),
    Scheduled(R.string.scheduled, R.color.status_scheduled),
    Active(R.string.status_active, R.color.status_active),
    Done(R.string.status_done, R.color.status_done);

    /** Convenience property to get the next status of a task */
    val nextStatus: TaskStatus
        get() = when (this) {
            Active -> Done
            Open -> Scheduled
            Scheduled -> Active
            Done -> throw AssertionError("Status 'Done' has no next status")
        }

    /** Convenience property to get the next statusID of a task */
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