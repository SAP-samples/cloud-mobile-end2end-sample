package com.sap.mobile.mahlwerk.screen

import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ViewModelProviders
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import com.sap.mobile.mahlwerk.viewmodel.MainViewModel

/**
 * Provides convenience access to several shared instances
 */
interface Screen {
    /** Convenience property to access the MahlwerkApplication */
    val mahlwerkApplication: MahlwerkApplication
        get() = requireActivity().application as? MahlwerkApplication
            ?: throw IllegalStateException("Application must be of type MahlwerkApplication")

    /** Convenience property to access the MainViewModel */
    val mainViewModel: MainViewModel
        get() = ViewModelProviders.of(
            requireActivity(),
            mahlwerkApplication.viewModelFactory
        )[MainViewModel::class.java]

    /**
     * This class needs an activity to get the shared instances
     */
    fun requireActivity(): FragmentActivity
}