package com.sap.mobile.mahlwerk.screen

import androidx.lifecycle.ViewModelProviders
import com.sap.mobile.mahlwerk.viewmodel.TaskViewModel

/**
 * Provides convenience access to the TaskViewModel
 */
interface TaskScreen : Screen {
    /** The ViewModel for the tasks tab */
    val viewModel: TaskViewModel
        get() = ViewModelProviders.of(
            requireActivity(),
            mahlwerkApplication.viewModelFactory
        )[TaskViewModel::class.java]
}