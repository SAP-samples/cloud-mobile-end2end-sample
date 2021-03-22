package com.sap.mobile.mahlwerk.layout

import android.content.Context
import androidx.recyclerview.widget.LinearLayoutManager

/**
 * A linear LayoutManager with disabled scrolling
 */
class NonScrollableLinearLayoutManager(context: Context): LinearLayoutManager(context) {

    override fun canScrollVertically(): Boolean {
        return false
    }

    override fun canScrollHorizontally(): Boolean {
        return false
    }
}