package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.View
import com.sap.cloud.android.odata.odataservice.Job
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.extension.jobStatus
import kotlinx.android.synthetic.main.item_job.*
import kotlinx.android.synthetic.main.item_suggested_job.*

/**
 * Adapter for the JobFragment
 */
class JobAdapter(context: Context) : GenericAdapter<Job>(context) {
    /** Indicates, if the current displayed task is assigned to the user */
    var isAssigned: Boolean = false

    /** Callback when user presses on the plus icon at a suggested job*/
    var onAddSuggestedJob: ((Job) -> Unit)? = null

    override var noItemsString = context.getString(R.string.noItems_job)

    /**
     * ViewHolder used to bind a job with the view
     */
    inner class JobViewHolder(
        view: View
    ) : ViewHolder<Job>(view) {

        override fun bind(data: Job) {
            val predictedTime = context.getString(R.string.predictedTime)
                .format(data.predictedWorkHours.toDouble())

            if (data.suggested) {
                textView_itemSuggestedJob_title.text = data.title
                textView_itemSuggestedJob_description.text = predictedTime

                if (isAssigned) {
                    imageView_itemSuggestedJob_add.setOnClickListener {
                        onAddSuggestedJob?.invoke(data)
                    }
                } else {
                    imageView_itemSuggestedJob_add.visibility = View.GONE
                }
            } else {
                textView_itemJob_title.text = data.title
                textView_itemJob_description.text = predictedTime
                textView_itemJob_status.text = data.jobStatus.getLocalizedString(context)
                textView_itemJob_status.setTextColor(data.jobStatus.getColor(context))
            }
        }
    }

    override fun getViewHolder(view: View, viewType: Int): ViewHolder<Job> {
        return JobViewHolder(view)
    }

    override fun getLayoutId(position: Int, item: Job): Int {
        return if (item.suggested) R.layout.item_suggested_job else R.layout.item_job
    }
}