package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.sap.mobile.mahlwerk.R
import kotlinx.android.extensions.LayoutContainer
import kotlinx.android.synthetic.main.item_no_items.*

/**
 * Generically typed class to handle the common portions of the adapters
 */
abstract class GenericAdapter<T>(
    protected val context: Context
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
    /** Items that will be displayed in the RecyclerView */
    open var items = listOf<T>()
        set(value) {
            field = value
            notifyDataSetChanged()
        }

    /** Callback function, that is called, when an item in the list is clicked */
    var onItemClick: ((item: T) -> Unit)? = null

    /** String to be displayed, when items in adapter are empty */
    abstract val noItemsString: String

    /**
     * Stores and recycles views as they are scrolled off screen
     */
    abstract inner class ViewHolder<T>(
        override val containerView: View
    ) : RecyclerView.ViewHolder(containerView), LayoutContainer {

        init {
            itemView.setOnClickListener { onItemClick(adapterPosition) }
        }

        abstract fun bind(data: T)
    }

    /**
     * ViewHolder used to bind the no items available string to the view
     */
    inner class NoItemsViewHolder(
        override val containerView: View
    ) : RecyclerView.ViewHolder(containerView), LayoutContainer {

        init {
            textView_items_title.text = noItemsString
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        if (items.isEmpty()) {
            return
        }

        @Suppress("UNCHECKED_CAST")
        (holder as? ViewHolder<T>)?.bind(items[position])
    }

    /**
     * Returns one if items are empty in order to display the no items string instead
     */
    override fun getItemCount(): Int {
        return if (items.isEmpty()) 1 else items.size
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        if (items.isEmpty()) {
            return NoItemsViewHolder(
                LayoutInflater.from(parent.context).inflate(viewType, parent, false)
            )
        }

        return getViewHolder(
            LayoutInflater.from(parent.context).inflate(viewType, parent, false),
            viewType
        )
    }

    /**
     * Override to show no items string if items are empty
     *
     * @param position position of the item
     */
    override fun getItemViewType(position: Int): Int {
        return if (items.isEmpty()) {
            R.layout.item_no_items
        } else {
            getLayoutId(position, items[position])
        }
    }

    /**
     * Abstract function, that the child has to implement in order to get the concrete ViewHolder
     *
     * @param view the view to be displayed
     * @param viewType the type of the view
     */
    protected abstract fun getViewHolder(view: View, viewType: Int): ViewHolder<T>

    /**
     * Layout id of the xml defining the item layout
     *
     * @param position the position of the clicked item in the RecyclerView
     * @param item the item to be displayed
     */
    protected abstract fun getLayoutId(position: Int, item: T): Int

    /**
     * Call the callback when item is clicked
     *
     * @param position the position of the clicked item in the RecyclerView
     */
    protected open fun onItemClick(position: Int) {
        onItemClick?.let { it(items[position]) }
    }
}