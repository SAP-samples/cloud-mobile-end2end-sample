package com.sap.mobile.mahlwerk.extension

import androidx.annotation.DrawableRes
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.navigation.ui.setupWithNavController

/**
 * Convenience function to setup the ActionBar with a toolbar, title, icon and a menu
 */
internal fun Fragment.setupActionBar(
    toolbar: Toolbar,
    title: String,
    @DrawableRes navigationIcon: Int? = null,
    hasMenu: Boolean = true
) {
    val activity = (activity as? AppCompatActivity)?.apply {
        setSupportActionBar(toolbar)
    }

    val navController = findNavController()
    toolbar.setupWithNavController(navController)

    navigationIcon?.let {
        toolbar.setNavigationIcon(it)
    }

    activity?.supportActionBar?.title = title
    setHasOptionsMenu(hasMenu)
}