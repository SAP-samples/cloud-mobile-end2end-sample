package com.sap.mobile.mahlwerk.repository

import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata.EntitySets
import com.sap.cloud.mobile.odata.EntitySet
import com.sap.cloud.mobile.odata.EntityValue
import com.sap.mobile.mahlwerk.service.SAPServiceManager
import java.util.*

/*
 * Repository factory to construct repository for an entity set
 */
class RepositoryFactory
/**
 * Construct a RepositoryFactory instance. There should only be one repository factory and used
 * throughout the life of the application to avoid caching entities multiple times.
 * @param sapServiceManager - Service manager for interaction with OData service
 */
(private val sapServiceManager: SAPServiceManager) {
    private val repositories: WeakHashMap<String, Repository<out EntityValue>> = WeakHashMap()

    /**
     * Construct or return an existing repository for the specified entity set
     * @param entitySet - entity set for which the repository is to be returned
     * @return a repository for the entity set
     */
    fun getRepository(entitySet: EntitySet): Repository<out EntityValue> {
        val odataService = sapServiceManager.odataService
            ?: throw IllegalStateException("Repository Factory requires a ODataService")

        val key = entitySet.localName
        var repository: Repository<out EntityValue>? = repositories[key]

        if (repository == null) {
            repository = when (key) {
                EntitySets.orderSet.localName -> OrderRepository(odataService)
                EntitySets.taskSet.localName -> TaskRepository(odataService)
                EntitySets.userSet.localName -> UserRepository(odataService)
                else -> throw AssertionError(
                    "Fatal error, entity set[$key] missing in generated code"
                )
            }
            repositories[key] = repository
        }
        return repository
    }

    /**
     * Get rid of all cached repositories
     */
    fun reset() {
        repositories.clear()
    }
}
