package com.sap.mobile.mahlwerk.screen

import androidx.lifecycle.ViewModelProviders
import com.sap.mobile.mahlwerk.viewmodel.ProfileViewModel

/**
 * Provides convenience access to the ProfileViewModel
 */
interface UserScreen : Screen {
    /** The ViewModel for the profile screen */
    val viewModel: ProfileViewModel
        get() = ViewModelProviders.of(
            requireActivity(),
            mahlwerkApplication.viewModelFactory
        )[ProfileViewModel::class.java]
}