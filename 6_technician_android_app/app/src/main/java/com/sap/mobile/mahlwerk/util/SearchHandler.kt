package com.sap.mobile.mahlwerk.util

import android.view.MenuItem
import android.view.View
import androidx.core.widget.NestedScrollView
import androidx.fragment.app.FragmentActivity
import androidx.recyclerview.widget.RecyclerView
import com.sap.cloud.mobile.fiori.search.FioriSearchView
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.SearchableAdapter
import com.sap.mobile.mahlwerk.extension.hideKeyboard

/**
 * Implements the logic of the
 */
interface SearchHandler {

    /**
     * Setup an SearchView with filters items in a RecyclerView
     *
     * @param activity the Activity of the Fragment
     * @param scrollView the ScrollView containing the RecyclerViews
     * @param menuItem the search menu item
     * @param recyclerViews the RecyclerViews to filter with the search string
     * @param viewsToHide to views to hide while searching
     * @param menuItemsToHide the menus to hide while searching
     */
    fun <T> setupSearchView(
        activity: FragmentActivity,
        scrollView: NestedScrollView,
        menuItem: MenuItem,
        recyclerViews: List<Pair<View, RecyclerView>>,
        viewsToHide: List<View>? = null,
        menuItemsToHide: List<MenuItem>? = null
    ) {
        val searchView = menuItem.actionView as? FioriSearchView
        searchView?.setFullScreenSuggestion(true)
        searchView?.setBackgroundResource(R.color.transparent)
        searchView?.maxWidth = Integer.MAX_VALUE
        searchView?.setOnQueryTextListener(
            object : androidx.appcompat.widget.SearchView.OnQueryTextListener {

                override fun onQueryTextSubmit(query: String?): Boolean {
                    activity.hideKeyboard()
                    return true
                }

                override fun onQueryTextChange(newText: String?): Boolean {
                    recyclerViews.forEach {
                        @Suppress("UNCHECKED_CAST")
                        val adapter = it.second.adapter as? SearchableAdapter<T>
                        adapter?.filter(newText ?: "")

                        it.first.visibility = when {
                            adapter?.itemCount == 0 -> View.GONE
                            else -> View.VISIBLE
                        }
                    }

                    return true
                }
            })

        menuItem.setOnActionExpandListener(object : MenuItem.OnActionExpandListener {
            override fun onMenuItemActionExpand(item: MenuItem?): Boolean {
                scrollView.scrollTo(0, 0)

                menuItemsToHide?.forEach { it.isVisible = false }
                viewsToHide?.forEach { it.visibility = View.GONE }

                activity.findViewById<View>(R.id.bottomNav_main)?.visibility = View.GONE
                return true
            }

            override fun onMenuItemActionCollapse(item: MenuItem?): Boolean {
                menuItemsToHide?.forEach { it.isVisible = true }
                viewsToHide?.forEach { it.visibility = View.VISIBLE }

                activity.findViewById<View>(R.id.bottomNav_main)?.visibility = View.VISIBLE
                return true
            }
        })
    }
}