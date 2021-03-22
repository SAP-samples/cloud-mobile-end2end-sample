package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.mobile.mahlwerk.repository.OrderRepository

/**
 * ViewModel used for the customer screen
 */
class CustomerViewModel(
    application: Application,
    odataService: OdataService
) : ViewModel(application, odataService) {
    /** Repository containing all orders */
    private val orderRepository = mahlwerkApplication.repositoryFactory
        .getRepository(OdataServiceMetadata.EntitySets.orderSet) as OrderRepository

    /** Orders of the repository as live data */
    val orders = orderRepository.observableEntities

    override fun refresh() {
        orderRepository.read()
    }

    override fun initialRead() {
        initialRead(orderRepository)
    }
}