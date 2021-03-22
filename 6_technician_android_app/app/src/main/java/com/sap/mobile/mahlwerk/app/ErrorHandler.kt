package com.sap.mobile.mahlwerk.app

import android.os.Handler
import android.os.HandlerThread
import android.os.Message

/**
 * Central handler class, which processes [ErrorMessage] notifications received from the application. The messages land
 * in an error queue and processed one-by-one. When the application is in foreground then each messages will be
 * presented on a dialog with a single 'OK' button. If a message contained an exception object, then its stack trace
 * will also be shown. If the message's fatal flag were 'true' then after pressing the OK button, the application is
 * shut down. If the application were in background then the dialogs appear after it returns to foreground.
 *
 * @constructor  The [ErrorHandler] is initialized using the [name] parameter of the [HandlerThread] constructor.
 *
 * @property [name] The name of the error handler.
 */
class ErrorHandler(name: String?) : HandlerThread(name) {

    private lateinit var handler : Handler
    lateinit var presenter : ErrorPresenter

    override fun onLooperPrepared() {

        handler = object : Handler(looper) {

            override fun handleMessage(msg: Message) {

                val errorTitle = msg.data.getString(ErrorMessage.KEY_TITLE)
                val errorDescription = msg.data.getString(ErrorMessage.KEY_DESC)
                val exception: Exception? = msg.data.get(ErrorMessage.KEY_EX) as? Exception
                val isFatal = msg.data.getBoolean(ErrorMessage.KEY_ISFATAL)

                presenter.presentError(errorTitle!!, errorDescription!!, exception, isFatal)
            }
        }
    }

    /**
     * This method is used to send [ErrorMessage] objects to the handler.
     *
     * @param error [ErrorMessage] object containing the error information
     */
    @Synchronized
    fun sendErrorMessage(error: ErrorMessage) {
        val errorBundle = error.errorBundle
        val errorMessage = Message.obtain(handler)
        errorMessage.data = errorBundle
        handler.sendMessage(errorMessage)
    }
}