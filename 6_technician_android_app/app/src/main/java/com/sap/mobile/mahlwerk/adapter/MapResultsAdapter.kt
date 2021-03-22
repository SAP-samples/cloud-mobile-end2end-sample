package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.View
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.fiori.maps.FioriMarkerOptions
import com.sap.cloud.mobile.fiori.maps.MapListPanel
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.model.TaskStatus
import kotlinx.android.synthetic.main.item_task.*

/**
 * Searchable Adapter for the tasks in the MapFragment
 */
class MapResultsAdapter(
    context: Context
) : SearchableAdapter<Task>(context), MapListPanel.MapListAdapter {
    override val noItemsString = context.getString(R.string.noItems_task)

    /** Tasks inside a selected cluster */
    private var taskIDs = listOf<Long>()

    /** Defines the filters for the tasks list*/
    private var filterValues = listOf(
        TaskStatus.Open,
        TaskStatus.Scheduled,
        TaskStatus.Active
    )

    /**
     * ViewHolder used to bind a task with the view
     */
    inner class MapViewHolder(
        view: View
    ) : GenericAdapter<Task>.ViewHolder<Task>(view) {

        override fun bind(data: Task) {
            val address = data.address
            val description = "${address.town}, ${address.street} ${address.houseNumber}"

            textView_itemTask_title.text = data.title
            textView_itemTask_description.text = description
            textView_itemTask_status.text = data.taskStatus.name
            textView_itemTask_status.setTextColor(data.taskStatus.getColor(context))
        }
    }

    override fun getViewHolder(view: View, viewType: Int): ViewHolder<Task> {
        return MapViewHolder(view)
    }

    override fun getLayoutId(position: Int, item: Task): Int {
        return R.layout.item_task
    }

    override fun filter(item: Task, text: String): Boolean {
        return (taskIDs.isEmpty() || taskIDs.contains(item.taskID))
            && item.title.contains(text, true) && filterValues.contains(item.taskStatus)
    }

    override fun clusterSelected(options: MutableList<FioriMarkerOptions>?) {
        options?.let {
            taskIDs = options.map { it.tag.toString().toLong() }
        }

        filter("")
    }

    /**
     * Sets the values of the filter of the map results
     * Only tasks which have the status of one of these filters will show in the list
     *
     * @param filterValues list of status that should be displayed
     */
    fun setFilterValues(filterValues: List<TaskStatus>?) {
        if (filterValues != null) {
            this.filterValues = filterValues
        }

        filter("")
    }
}