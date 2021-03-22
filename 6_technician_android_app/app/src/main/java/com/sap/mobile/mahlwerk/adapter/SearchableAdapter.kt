package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import androidx.recyclerview.widget.RecyclerView
import com.sap.mobile.mahlwerk.R

/**
 * Generic Adapter that implements a filter to support searching in the items of the RecyclerView
 */
abstract class SearchableAdapter<T>(context: Context) : GenericAdapter<T>(context) {
    /** List of the filtered items that will be displayed */
    private var filteredItems = mutableListOf<T>()

    /**
     * Overrides the items that the adapter holds
     * If the value will be set, the filtered items will also be set to this value
     */
    override var items: List<T>
        get() = super.items
        set(value) {
            filteredItems = mutableListOf<T>().apply { addAll(value) }
            super.items = value
        }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        if (filteredItems.isEmpty()) {
            return
        }

        @Suppress("UNCHECKED_CAST")
        (holder as? ViewHolder<T>)?.bind(filteredItems[position])
    }

    /**
     * Return number of the filtered items
     * Returns one if items are empty in order to display the no items string instead
     */
    override fun getItemCount(): Int {
        return if (filteredItems.isEmpty()) 1 else filteredItems.size
    }

    /**
     * Overrides the onItemClick method in order to make it listen only on the filtered items
     *
     * @param position the position of the clicked item in the RecyclerView
     */
    override fun onItemClick(position: Int) {
        onItemClick?.let { it(filteredItems[position]) }
    }

    /**
     * Show no items string if filteredItems are empty
     */
    override fun getItemViewType(position: Int): Int {
        return if (filteredItems.isEmpty()) {
            R.layout.item_no_items
        } else {
            getLayoutId(position, items[position])
        }
    }

    /**
     * Filter items with a search string
     *
     * @param text the text that is entered in the search field
     */
    fun filter(text: String) {
        filteredItems = items.filter { filter(it, text) }.toMutableList()
        notifyDataSetChanged()
    }

    /**
     * Function, that is implemented in the concrete subclass that returns a
     * boolean indicating if the item should be visible or not
     *
     * @param item the item for which the filter should decide
     * @param text the text that is entered in the search field
     */
    abstract fun filter(item: T, text: String): Boolean
}