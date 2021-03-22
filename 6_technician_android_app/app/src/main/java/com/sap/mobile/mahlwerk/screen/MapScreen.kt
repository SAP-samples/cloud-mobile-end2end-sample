package com.sap.mobile.mahlwerk.screen

import androidx.lifecycle.ViewModelProviders
import com.sap.mobile.mahlwerk.viewmodel.MapViewModel

/**
 * Provides convenience access to the MapViewModel
 */
interface MapScreen : Screen {
    /** The ViewModel for the map tab */
    val viewModel: MapViewModel
        get() = ViewModelProviders.of(
            requireActivity(),
            mahlwerkApplication.viewModelFactory
        )[MapViewModel::class.java]
}