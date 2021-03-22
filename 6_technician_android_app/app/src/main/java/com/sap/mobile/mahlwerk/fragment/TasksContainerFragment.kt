package com.sap.mobile.mahlwerk.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.sap.mobile.mahlwerk.R

/**
 * This fragment is a container for the tasks tab in the BottomNavigationView
 */
class TasksContainerFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_tasks_container, container, false)
    }
}
