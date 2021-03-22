package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.View
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.extension.taskStatus
import kotlinx.android.synthetic.main.item_task.*

/**
 * Adapter for the tasks list in the TasksFragment
 */
class TaskAdapter(context: Context) : SearchableAdapter<Task>(context) {
    override var noItemsString = context.getString(R.string.noItems_task)

    /**
     * ViewHolder used to bind a task with the view
     */
    inner class TaskViewHolder(
        view: View
    ) : GenericAdapter<Task>.ViewHolder<Task>(view) {

        override fun bind(data: Task) {
            val address = data.address
            val description = "${address.town}, ${address.street} ${address.houseNumber}"

            textView_itemTask_title.text = data.title
            textView_itemTask_description.text = description
            textView_itemTask_status.text = data.taskStatus.getLocalizedString(context)
            textView_itemTask_status.setTextColor(data.taskStatus.getColor(context))
        }
    }

    override fun getViewHolder(view: View, viewType: Int): ViewHolder<Task> {
        return TaskViewHolder(view)
    }

    override fun getLayoutId(position: Int, item: Task): Int {
        return R.layout.item_task
    }

    override fun filter(item: Task, text: String): Boolean {
        return item.title.contains(text, true)
    }
}