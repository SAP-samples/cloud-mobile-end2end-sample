package com.sap.mobile.mahlwerk.screen

import androidx.lifecycle.ViewModelProviders
import com.sap.mobile.mahlwerk.viewmodel.CustomerViewModel

/**
 * Provides convenience access to the CustomerViewModel
 */
interface CustomerScreen : Screen {
    /** The ViewModel for the customer screen */
    val viewModel: CustomerViewModel
        get() = ViewModelProviders.of(
            requireActivity(),
            mahlwerkApplication.viewModelFactory
        )[CustomerViewModel::class.java]
}