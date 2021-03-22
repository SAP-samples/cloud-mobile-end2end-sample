package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.mobile.mahlwerk.repository.UserRepository

/**
 * ViewModel used for the profile screen
 */
class ProfileViewModel(
    application: Application,
    odataService: OdataService
) : ViewModel(application, odataService) {
    /** Repository containing all users */
    private val userRepository = mahlwerkApplication.repositoryFactory
        .getRepository(OdataServiceMetadata.EntitySets.userSet) as UserRepository

    /** Users of the repository */
    val users = userRepository.observableEntities

    override fun refresh() {
        userRepository.read()
    }

    override fun initialRead() {
        initialRead(userRepository)
    }
}