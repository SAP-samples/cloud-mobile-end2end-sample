package com.sap.mobile.mahlwerk.repository

import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.cloud.android.odata.odataservice.Order
import com.sap.cloud.mobile.odata.SortOrder

/**
 * Repository for orders
 */
class OrderRepository(odataService: OdataService) : Repository<Order>(
    odataService,
    OdataServiceMetadata.EntitySets.orderSet,
    Order.orderStatusID, SortOrder.DESCENDING
)