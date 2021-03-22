package com.sap.mobile.mahlwerk.util

import android.content.Context
import android.util.AttributeSet
import android.view.KeyEvent
import android.view.MotionEvent
import androidx.viewpager.widget.ViewPager

/**
 * ViewPager that disables the horizontal swipe events for the use in the BottomNavigationView
 */
class NonSwipeableViewPager(context: Context, attrs: AttributeSet) : ViewPager(context, attrs) {

    override fun onTouchEvent(event: MotionEvent): Boolean {
        return false
    }

    override fun onInterceptTouchEvent(event: MotionEvent): Boolean {
        return false
    }

    override fun executeKeyEvent(event: KeyEvent): Boolean {
        return false
    }
}