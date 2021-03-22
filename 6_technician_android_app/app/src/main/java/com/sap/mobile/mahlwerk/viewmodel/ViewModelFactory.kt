package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.sap.cloud.android.odata.odataservice.OdataService

/**
 * Factory for all view models that injects the ODataService into the view models
 */
class ViewModelFactory(
    private val application: Application,
    private val odataService: OdataService
) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        when (modelClass) {
            MainViewModel::class.java -> return MainViewModel(application) as T
            TaskViewModel::class.java -> return TaskViewModel(application, odataService) as T
            MapViewModel::class.java -> return MapViewModel(application, odataService) as T
            ProfileViewModel::class.java -> return ProfileViewModel(application, odataService) as T
            CustomerViewModel::class.java -> return CustomerViewModel(
                application,
                odataService
            ) as T
        }

        throw IllegalArgumentException("No ViewModel found for: $modelClass")
    }
}