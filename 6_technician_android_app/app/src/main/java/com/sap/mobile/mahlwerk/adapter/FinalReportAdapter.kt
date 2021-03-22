package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.View
import com.sap.cloud.android.odata.odataservice.Job
import com.sap.mobile.mahlwerk.R
import kotlinx.android.synthetic.main.item_final_report.*

/**
 * Adapter for the FinalReportFragment
 */
class FinalReportAdapter(context: Context) : GenericAdapter<Job>(context) {
    override val noItemsString = context.getString(R.string.noItems_job)

    /**
     * ViewHolder for the FinalReport used to bind a job with the view
     */
    inner class FinalReportViewHolder(
            view: View
    ) : ViewHolder<Job>(view) {

        override fun bind(data: Job) {
            val actualTime = context.getString(R.string.hours)
                    .format(data.actualWorkHours?.toDouble())

            textView_itemFinalReport_title.text = data.title
            textView_itemFinalReport_hours.text = actualTime

            FinalReportMaterialAdapter(context).apply {
                items = data.materialPosition.map { it.material to it.quantity }.toMutableList()
                recyclerView_itemFinalReport.adapter = this
            }
        }
    }

    override fun getViewHolder(view: View, viewType: Int): ViewHolder<Job> {
        return FinalReportViewHolder(view)
    }

    override fun getLayoutId(position: Int, item: Job): Int {
        return R.layout.item_final_report
    }
}