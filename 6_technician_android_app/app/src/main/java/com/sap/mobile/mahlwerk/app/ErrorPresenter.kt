package com.sap.mobile.mahlwerk.app

/**
 * This is a general interface, which is used by the [ErrorHandler] to present error messages to the user. The default
 * implementation is based on notification dialogs, but by the implementation of this interface this can be customized
 * by the application developer.
 */
interface ErrorPresenter {
    /**
     * This method is called by the [ErrorHandler] to show error messages to the application's user.
     *
     * @property [errorTitle] short title for the error
     * @property [errorDetail] detailed error description, which contains also the consequences of the problem
     * @property [exception] catched exception might also be attached
     * @property [isFatal] flag to indicate, whether the application could still work (maybe with limited functionality)
     */
    fun presentError(errorTitle: String, errorDetail: String, exception: Exception?, isFatal: Boolean)
}