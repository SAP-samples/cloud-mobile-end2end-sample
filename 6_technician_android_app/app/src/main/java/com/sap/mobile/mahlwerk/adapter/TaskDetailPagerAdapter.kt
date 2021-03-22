package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.fragment.TaskJobsFragment
import fragment.TaskInformationFragment

/**
 * PagerAdapter that returns the corresponding content fragment
 * for the selected tab in the TaskDetailFragment
 */
class TaskDetailPagerAdapter(
    private val context: Context,
    manager: FragmentManager
) : FragmentPagerAdapter(manager, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

    override fun getItem(position: Int): Fragment {
        when (position) {
            0 -> return TaskInformationFragment()
            1 -> return TaskJobsFragment()
//            2 -> return TaskMaterialFragment()
        }

        throw IllegalArgumentException("No item found for position: $position")
    }

    override fun getPageTitle(position: Int): CharSequence? {
        when (position) {
            0 -> return context.getString(R.string.information)
            1 -> return context.getString(R.string.jobs)

//            2 -> return context.getString(R.string.materials)
        }

        throw IllegalArgumentException("No title found for position: $position")
    }

    override fun getCount(): Int {
        return 2
    }
}