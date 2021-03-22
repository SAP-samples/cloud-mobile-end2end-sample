package com.sap.mobile.mahlwerk.adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import com.sap.mobile.mahlwerk.fragment.MapContainerFragment
import com.sap.mobile.mahlwerk.fragment.TasksContainerFragment

/**
 * ViewPagerAdapter for the BottomNavigationView
 * Returns a container view for each tab for each tab item
 */
class ContentViewPagerAdapter(
    manager: FragmentManager
) : FragmentPagerAdapter(manager, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

    override fun getItem(position: Int): Fragment {
        when (position) {
            0 -> return TasksContainerFragment()
            1 -> return MapContainerFragment()
        }

        throw IllegalArgumentException("No item found for position: $position")
    }

    override fun getCount(): Int {
        return 2
    }
}