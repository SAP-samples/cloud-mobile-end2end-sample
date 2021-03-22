package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.MutableLiveData
import com.sap.cloud.android.odata.odataservice.Customer
import com.sap.cloud.android.odata.odataservice.Order
import com.sap.cloud.android.odata.odataservice.Task

/**
 * ViewModel with the scope of the whole main application
 * Mostly used to navigate between the tabs of the BottomNavigationView
 */
class MainViewModel(application: Application) : AndroidViewModel(application) {
    /**The recent selected customer in one of the screens */
    val selectedCustomer = MutableLiveData<Customer>()

    /** Callback for navigating to the task detail screen */
    var onNavigateToTaskDetail: (() -> Unit)? = null

    /** Callback for navigating to the map screen */
    var onNavigateToMap: (() -> Unit)? = null

    /** Callback for navigating to the final report screen */
    var onNavigateToFinalReport: (() -> Unit)? = null

    /** Callback for selecting the task after switching the tasks in the BottomNavigationView */
    var onSelectTask: ((Task) -> Unit)? = null

    /** Callback for selecting the task after switching to the map in the BottomNavigationView */
    var onSelectMapTask: ((Task) -> Unit)? = null

    /** Callback for selecting the task after switching to the FinalReportFragment */
    var onSelectFinalReportTask: ((Task) -> Unit)? = null

    /**
     * Navigates to the TaskDetailFragment and displays the selected task
     *
     * @param task the task to be selected after the navigation
     */
    fun navigateToTaskDetail(task: Task) {
        onNavigateToTaskDetail?.invoke()
        onSelectTask?.invoke(task)
    }

    /**
     * Navigates to the MapFragment and displays the selected task
     *
     * @param task the task to be selected after the navigation
     */
    fun navigateToMapAndSelectTask(task: Task) {
        onNavigateToMap?.invoke()
        onSelectMapTask?.invoke(task)
    }

    /**
     * Navigates to the FinalReportFragment and displays the final report of the task
     *
     * @param task the task to display the final report
     */
    fun navigateToFinalReport(task: Task) {
        onNavigateToFinalReport?.invoke()
        onSelectFinalReportTask?.invoke(task)
    }
}