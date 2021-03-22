package com.sap.mobile.mahlwerk.view

import android.content.Context
import android.util.AttributeSet
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

/**
 * RecyclerView used inside of a NestedScrollView
 * This RecyclerView disables the scrolling of its items and sets a divider
 */
class NestedRecyclerView(
    context: Context,
    attrs: AttributeSet
) : RecyclerView(context, attrs) {

    init {
        isNestedScrollingEnabled = false
        layoutManager = LinearLayoutManager(context)

        val divider = DividerItemDecoration(context, DividerItemDecoration.VERTICAL)
        addItemDecoration(divider)
    }
}