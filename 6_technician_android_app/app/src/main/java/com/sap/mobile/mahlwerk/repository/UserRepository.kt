package com.sap.mobile.mahlwerk.repository

import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.cloud.android.odata.odataservice.User

/**
 * Repository for users
 */
class UserRepository(odataService: OdataService) : Repository<User>(
    odataService,
    OdataServiceMetadata.EntitySets.userSet
)