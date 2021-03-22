package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.View
import com.sap.cloud.android.odata.odataservice.Material
import com.sap.mobile.mahlwerk.R
import kotlinx.android.synthetic.main.item_final_report_material.*

/**
 * Adapter for the materials in the FinalReportFragment
 */
class FinalReportMaterialAdapter(
    context: Context
) : GenericAdapter<Pair<Material, Short>>(context) {
    override val noItemsString = context.getString(R.string.noItems_material)

    /**
     * ViewHolder for the FinalReportMaterial used to bind a material with the view
     */
    inner class FinalReportMaterialViewHolder(
        view: View
    ) : ViewHolder<Pair<Material, Short>>(view) {

        override fun bind(data: Pair<Material, Short>) {
            textView_itemFinalReportMaterial_title.text = data.first.name
            textView_itemFinalReportMateria_quantity.text = context.getString(
                R.string.quantity,
                data.second
            )
        }
    }

    override fun getViewHolder(view: View, viewType: Int): ViewHolder<Pair<Material, Short>> {
        return FinalReportMaterialViewHolder(view)
    }

    override fun getLayoutId(position: Int, item: Pair<Material, Short>): Int {
        return R.layout.item_final_report_material
    }
}