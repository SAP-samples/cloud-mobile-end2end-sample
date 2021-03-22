package com.sap.mobile.mahlwerk.activity

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProviders
import androidx.navigation.NavController
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.fragment.findNavController
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.ContentViewPagerAdapter
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import com.sap.mobile.mahlwerk.fragment.MapContainerFragment
import com.sap.mobile.mahlwerk.fragment.TasksContainerFragment
import com.sap.mobile.mahlwerk.viewmodel.*
import kotlinx.android.synthetic.main.activity_main.*

/**
 * This Activity is the main activity of the app after the onbarding
 */
class MainActivity : AppCompatActivity() {
    /** Adapter for the view pager in the BottomNaviationView */
    private val adapter by lazy { ContentViewPagerAdapter(supportFragmentManager) }

    /** Main view model with the scope of all fragments */
    private val viewModel by lazy {
        ViewModelProviders.of(
                this,
                (application as MahlwerkApplication).viewModelFactory
        )[MainViewModel::class.java]
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        performInitialRead()
        viewPager_main.adapter = adapter

        bottomNav_main.setOnNavigationItemSelectedListener { item ->
            when (item.itemId) {
                R.id.fragment_tasks -> viewPager_main.currentItem = 0
                R.id.fragment_map -> viewPager_main.currentItem = 1
            }

            true
        }

        viewModel.onNavigateToTaskDetail = navigateToTaskDetail
        viewModel.onNavigateToMap = navigateToMap
        viewModel.onNavigateToFinalReport = navigateToFinalReport
    }

    /**
     * On Android Back-Button press, navigate to the last visited screen in the tab
     * Without this function, a back press would quit the app
     */
    override fun onBackPressed() {
        val navController = findNavController()
        if (navController?.graph?.startDestination != navController?.currentDestination?.id) {
            navController?.popBackStack()
        } else if (bottomNav_main.selectedItemId == R.id.fragment_map) {
            bottomNav_main.selectedItemId = R.id.fragment_tasks
        } else {
            super.onBackPressed();
        }
    }

    /**
     * Navigates to the Task detail screen
     */
    private val navigateToTaskDetail: (() -> Unit) = {
        bottomNav_main.selectedItemId = R.id.fragment_tasks
        val navController = findNavController()
        navController?.popBackStack(R.id.tasksFragment, false)
        navController?.navigate(R.id.action_tasksFragment_to_taskDetailFragment)
    }

    /**
     * Navigates to the map tab and selects the selected task
     */
    private val navigateToMap: (() -> Unit) = {
        bottomNav_main.selectedItemId = R.id.fragment_map
    }

    /**
     * Navigates to the final report screen
     */
    private val navigateToFinalReport: (() -> Unit) = {
        bottomNav_main.selectedItemId = R.id.fragment_tasks
        val navController = findNavController()
        navController?.popBackStack(R.id.tasksFragment, false)
        navController?.navigate(R.id.action_tasksFragment_to_taskDetailFragment)
        navController?.navigate(R.id.action_taskDetailFragment_to_finalReportFragment)
    }

    /**
     * Convenience function, that returns the NavController of the selected tab
     */
    private fun findNavController(): NavController? {
        val containerClass = when (bottomNav_main.selectedItemId) {
            R.id.fragment_tasks -> TasksContainerFragment::class
            R.id.fragment_map -> MapContainerFragment::class
            else -> return null
        }

        return supportFragmentManager.fragments.find {
            it::class == containerClass
        }?.childFragmentManager?.fragments?.find {
            it is NavHostFragment
        }?.findNavController()
    }

    /**
     * Performs the initial read of the Repositories
     */
    private fun performInitialRead() {
        val factory = (application as MahlwerkApplication).viewModelFactory
        ViewModelProviders.of(this, factory)[TaskViewModel::class.java].initialRead()
        ViewModelProviders.of(this, factory)[MapViewModel::class.java].initialRead()
        ViewModelProviders.of(this, factory)[ProfileViewModel::class.java].initialRead()
    }
}