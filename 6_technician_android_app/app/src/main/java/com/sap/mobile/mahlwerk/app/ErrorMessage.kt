package com.sap.mobile.mahlwerk.app

import android.os.Bundle

/**
 * Simple wrapper class for error messages, which are used to send notifications to the [ErrorHandler].
 *
 * @constructor Error messages have a (short) [title] and a longer [description]. If an [exception] is also attached,
 * then its stack trace will be processed and presented to the user. [isFatal] argument could indicate whether the
 * application can still work (isFatal = false) with somewhat limited functionality or it should be shut down by the
 * error handler (isFatal = true).
 *
 * @property [title] The title of the error message.
 * @property [description] The description of the error message explaining also the consequences of the error.
 * @property [exception] The exception to be processed and presented to the user.
 * @property [isFatal] The flag which indicates the severity of the error. When true application shall not be continued.
 *
 * @property [errorBundle] A [Bundle] containing the error parameters with the self-explaining keys [keyTitle],
 * [keyDesc], [keyException] and [keyIsFatal], for the title, description, exception object and error severity.
 */
class ErrorMessage(private val title: String = "Error!", private val description: String = "") {

    private var exception: Exception? = null
    private var isFatal: Boolean = false

    var errorBundle: Bundle
        private set

    init {
        errorBundle = Bundle()
        errorBundle.putString(KEY_TITLE, title)
        errorBundle.putString(KEY_DESC, description)
        errorBundle.putSerializable(KEY_EX, exception)
        errorBundle.putBoolean(KEY_ISFATAL, isFatal)
    }

    constructor(title: String, description: String, exception: Exception?, isFatal: Boolean) : this(title, description) {
        this.exception = exception
        this.isFatal = isFatal
    }

    companion object {
        const val KEY_TITLE = "TITLE"
        const val KEY_DESC = "DESC"
        const val KEY_EX = "EX"
        const val KEY_ISFATAL = "ISFATAL"
    }
}