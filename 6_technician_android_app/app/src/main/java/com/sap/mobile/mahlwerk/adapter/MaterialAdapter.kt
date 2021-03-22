package com.sap.mobile.mahlwerk.adapter

import android.content.Context
import android.view.View
import com.sap.cloud.android.odata.odataservice.Material
import com.sap.mobile.mahlwerk.R
import kotlinx.android.synthetic.main.item_material.*

/**
 * Adapter for the Materials in the TasksFragment
 */
class MaterialAdapter(context: Context) : GenericAdapter<Pair<Material, Short>>(context) {
    override val noItemsString = context.getString(R.string.noItems_material)

    /**
     * ViewHolder used to bind a material with the view
     */
    inner class MaterialViewHolder(
        view: View
    ) : GenericAdapter<Pair<Material, Short>>.ViewHolder<Pair<Material, Short>>(view) {

        override fun bind(data: Pair<Material, Short>) {
            textView_itemMaterial_title.text = data.first.name
            textView_itemMaterial_quantity.text = context.getString(
                R.string.quantity,
                data.second
            )
        }
    }

    override fun getViewHolder(view: View, viewType: Int): ViewHolder<Pair<Material, Short>> {
        return MaterialViewHolder(view)
    }

    override fun getLayoutId(position: Int, item: Pair<Material, Short>): Int {
        return R.layout.item_material
    }
}