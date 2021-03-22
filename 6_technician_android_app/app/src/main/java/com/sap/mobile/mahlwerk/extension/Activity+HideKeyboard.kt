package com.sap.mobile.mahlwerk.extension

import android.app.Activity
import android.view.inputmethod.InputMethodManager

/**
 * Convenience function to hide the android keyboard
 */
fun Activity.hideKeyboard() {
    val inputMethodManager = getSystemService(Activity.INPUT_METHOD_SERVICE) as? InputMethodManager
    inputMethodManager?.hideSoftInputFromWindow(currentFocus?.windowToken, 0)
}