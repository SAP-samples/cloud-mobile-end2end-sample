package com.sap.mobile.mahlwerk.repository

import androidx.lifecycle.MutableLiveData
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.mobile.odata.*
import com.sap.cloud.mobile.odata.core.Action0
import com.sap.cloud.mobile.odata.core.Action1
import com.sap.cloud.mobile.odata.http.HttpHeaders
import com.sap.mobile.mahlwerk.archcomp.SingleLiveEvent
import com.sap.mobile.mahlwerk.repository.OperationResult.Operation
import org.slf4j.LoggerFactory

/**
 * Generic type representing repository with type being one of the entity types.
 * In other words, each entity type has its own repository and an in-memory store of all the entities
 * of that type.
 * Repository exposed the list of entities as LiveData and four events (CRUD) as SingleLiveEvent
 * @param odataService OData service
 * @param entitySet entity set associated with this repository
 * @param orderByProperty used to order the collection retrieved from OData service
 */
abstract class Repository<T : EntityValue>(
    protected val odataService: OdataService,
    private val entitySet: EntitySet,
    private val orderByProperty: Property? = null,
    private val sortOrder: SortOrder = SortOrder.ASCENDING
) {
    /*
     * Cache is only in-memory but can be extended to persist to avoid fetching on application re-launches
     */
    protected val entities: MutableList<T>
    
    /*
     * Cache for the related entities
     */
    private var relatedEntities: MutableList<T>

    /*
     * LiveData for the list of entities returned by OData service for this entity set
     */
    val observableEntities: MutableLiveData<List<T>>

    /*
     * Event to notify of async completion of create operation
     */
    val createResult = SingleLiveEvent<OperationResult<T>>()

    /*
     * Event to notify of async completion of read/query operation
     */
    val readResult = SingleLiveEvent<OperationResult<T>>()

    /*
     * Event to notify of async completion of update operation
     */
    val updateResult = SingleLiveEvent<OperationResult<T>>()

    /*
     * Event to notify of async completion of delete operation
     */
    val deleteResult = SingleLiveEvent<OperationResult<T>>()

    /**
     * Flag to indicate if repository has been populated with an initial read
     */
    private var initialReadDone: Boolean = false


    init {
        entities = ArrayList()
        relatedEntities = ArrayList()
        observableEntities = MutableLiveData()
    }

    /*
     * For convenience of code generation, read is implemented using dynamic API.
     * However, if we are to create an entity set specific repository, it is highly recommended that
     * the generated getters for the entity set being utilized as they return strongly type proxy class
     * that will simplify consumption. For example, get<entity set>Async should be used to simplify the
     * implementation for read when we are dealing the entity type associated with the entity set.
     *
     * Read method to retrieve all entities of the entity set
     */
    @Suppress("UNCHECKED_CAST")
    fun read() {
        relatedEntities.clear()
        
        var dataQuery = DataQuery().from(entitySet)

        if (orderByProperty != null) {
            dataQuery = dataQuery.orderBy(orderByProperty, sortOrder)
        }

        odataService.executeQueryAsync(
            dataQuery,
            { result ->
                val entitiesRead = this.convert(result.entityList)
                entities.clear()
                entities.addAll(entitiesRead)
                // Update observables
                observableEntities.value = entitiesRead
                val operationResult: OperationResult<T> = OperationResult(Operation.READ)
                readResult.setValue(operationResult)
            },
            { error ->
                LOGGER.debug("Error encountered during fetch of Category collection", error)
                val operationResult: OperationResult<T> = OperationResult(error, Operation.READ)
                readResult.setValue(operationResult)
            },
            HttpHeaders.empty
        )
    }

    /**
     * This version of the read operation is used to get the related objects to a
     * given entity.
     *
     * @param parent - the original entity, the starting point of the navigation
     * @param navigationPropertyName - the name of the link to the related entity set
     */
    @Suppress("UNCHECKED_CAST")
    fun read(parent: EntityValue, navigationPropertyName: String) {
        relatedEntities.clear()
    
        val navigationProperty = parent.entityType.getProperty(navigationPropertyName)
        var dataQuery = DataQuery()
        if (navigationProperty.isCollection && orderByProperty != null) {
            dataQuery = dataQuery.orderBy(orderByProperty, sortOrder)
        }
        odataService.loadPropertyAsync(navigationProperty, parent, dataQuery,
            {
                val relatedData = parent.getDataValue(navigationProperty)
                relatedEntities = ArrayList()
                when (navigationProperty.dataType.code) {
                    DataType.ENTITY_VALUE_LIST -> relatedEntities = this.convert((relatedData as EntityValueList?)!!)
                    DataType.ENTITY_VALUE -> if (relatedData != null) {
                        val entity = relatedData as EntityValue?
                        relatedEntities.add(entity as T)
                    }
                }
                initialReadDone = true
                
                // Update observables
                observableEntities.value = relatedEntities
                val operationResult = OperationResult<T>(Operation.READ)
                readResult.setValue(operationResult)
            },
            { error ->
                LOGGER.debug("Error encountered during fetch of Category collection", error)
                val operationResult: OperationResult<T> = OperationResult(error, Operation.READ)
                readResult.setValue(operationResult)
            },
            HttpHeaders.empty)
    }

    /**
     * Create method for Entity type that is a Media Linked Entity
     * caller must provide the media resource associated with the MLE
     *
     * @param newEntity - the MLE entity instance
     * @param media - byte or character stream of the media resource
     */
    fun create(newEntity: T, media: StreamBase) {
        if (newEntity.entityType.isMedia) {
            odataService.createMediaAsync(newEntity, media,
                {
                    insertToCache(newEntity, entities)
                    if (relatedEntities.size > 0) {
                        insertToCache(newEntity, relatedEntities)
                        observableEntities.value = relatedEntities
                    } else {
                        observableEntities.value = entities
                    }
                    
                    val operationResult: OperationResult<T> = OperationResult(newEntity, Operation.CREATE)
                    createResult.setValue(operationResult)
                },
                { error ->
                    LOGGER.debug("Media Linked Entity creation failed:", error)
                    val operationResult: OperationResult<T> = OperationResult(error, Operation.CREATE)
                    createResult.setValue(operationResult)
                })
        }
    }

    /**
     * Create method for the entity set
     *
     * @param newEntity - entity to create
     */
    fun create(newEntity: T) {
        if (newEntity.entityType.isMedia) {
            val operationResult: OperationResult<T> = OperationResult(
                IllegalStateException("Specify media resource for Media Linked Entity"),
                Operation.CREATE
            )
            createResult.value = operationResult
            return
        }
        odataService.createEntityAsync(newEntity,
            {
                insertToCache(newEntity, entities)
                if (relatedEntities.size > 0) {
                    insertToCache(newEntity, relatedEntities)
                    observableEntities.value = relatedEntities
                } else {
                    observableEntities.value = entities
                }
                
                val operationResult: OperationResult<T> = OperationResult(newEntity, Operation.CREATE)
                createResult.setValue(operationResult)
            },
            { error ->
                LOGGER.debug("Entity creation failed:", error)
                val operationResult: OperationResult<T> = OperationResult(error, Operation.CREATE)
                createResult.setValue(operationResult)
            })
    }

    /**
     * Update method for the entity set
     *
     * @param updateEntity - entity to update
     */
    fun update(updateEntity: T) {
        odataService.updateEntityAsync(
            updateEntity,
            {
                replaceInCache(updateEntity, entities)
                if (relatedEntities.size > 0) {
                    replaceInCache(updateEntity, relatedEntities)
                    observableEntities.value = relatedEntities
                } else {
                    observableEntities.value = entities
                }

                val operationResult: OperationResult<T> = OperationResult(updateEntity, Operation.UPDATE)
                updateResult.setValue(operationResult)
            },
            { error ->
                LOGGER.debug("Error encountered during update of entity", error)
                val operationResult: OperationResult<T> = OperationResult(error, Operation.UPDATE)
                updateResult.setValue(operationResult)
            })
    }

    /**
     * Delete method for the entity set
     * @param deleteEntities - list of entities to be deleted
     *
     * Implementation uses a ChangeSet to guarantee that either all specified entities are deleted or none
     * For best effort delete, multiple ChangeSets within a Batch can be used
     */
    fun delete(deleteEntities: MutableList<T>) {
        val deleteChangeSet = ChangeSet()
        for (entityToDelete in deleteEntities) {
            deleteChangeSet.deleteEntity(entityToDelete)
        }
        odataService.applyChangesAsync(
            deleteChangeSet,
            {
                // Change Set success means all deletes are completed
                for (entityToDelete in deleteEntities) {
                    if (relatedEntities.size > 0) {
                        removeFromCache(entityToDelete, relatedEntities)
                    }
                    removeFromCache(entityToDelete, entities)
                }
                
                if (relatedEntities.size > 0) {
                    observableEntities.value = relatedEntities
                } else {
                    observableEntities.value = entities
                }

                val operationResult: OperationResult<T> = OperationResult(deleteEntities, Operation.DELETE)
                deleteResult.setValue(operationResult)
            },
            { error ->
                LOGGER.debug("Error encountered during deletion of entities:", error)
                    val operationResult: OperationResult<T> = OperationResult(error, Operation.DELETE)
                    deleteResult.setValue(operationResult)
            })
    }

    /**
     * Download media associated with the media linked entity
     *
     * @param [entity] media linked entity
     * @param [successHandler] called when download is successful
     * @param [failureHandler] called when failure occurred during download
     */
    fun downloadMedia(
        entity: T, successHandler: Action1<ByteArray>,
        failureHandler: Action1<RuntimeException>
    ) {
        odataService.downloadMediaAsync(
            entity,
                { media-> successHandler.call(media) },
                { error->
                    LOGGER.debug("Error encountered during download of MLE media resource", error)
                    failureHandler.call(error)
                }
        )
    }

    /**
     * For use by View Model to populate the repository. Only if an initial read has not been done will
     * an attempt be made to read in data from the collection.
     *
     * @param failureHandler
     */
    fun initialRead(successHandler: Action0?, failureHandler: Action1<RuntimeException>) {
        relatedEntities.clear()
    
        if (initialReadDone && entities.size > 0) {
            observableEntities.value = entities
            return
        }

        var dataQuery = DataQuery().from(entitySet)
        if (orderByProperty != null) {
            dataQuery = dataQuery.orderBy(orderByProperty, sortOrder)
        }

        odataService.executeQueryAsync(dataQuery,
            Action1 { queryResult ->
                val entitiesRead = convert(queryResult.entityList)
                entities.clear()
                entities.addAll(entitiesRead)
                initialReadDone = true
                observableEntities.value = entitiesRead
                successHandler?.call()
            },
            failureHandler,
            HttpHeaders.empty)
    }

    /*
     * A simple function to convert from generic EntityValueList to type specified list
     */
    @Suppress("UNCHECKED_CAST")
    protected fun convert(entityValueList: EntityValueList): ArrayList<T> {
        val result = ArrayList<T>(entityValueList.length())
        val iterator = entityValueList.iterator()
        while (iterator.hasNext()) {
            result.add(iterator.next() as T)
        }
        return result
    }

    /**
     * Insert the new entity into cache and in order if needed
     *
     * @param newEntity
     * @param cache
     */
    protected fun insertToCache(newEntity: T, cache: MutableList<T>) {
        if (orderByProperty != null) {
            insertOrderByProperty(newEntity, cache)
        } else {
            cache.add(0, newEntity)
        }
    }

    /**
     * Replace the entity in cache that has the same key(s) of the updated entity
     * Since we do not know if the value for order by property has been change, we have to do remove
     * followed by insert
     * Note: implementation should be optimized to obtain better than linear scaling for very large collection
     *
     * @param updateEntity - updated entity to be replaced with
     * @param cache
     */
    protected fun replaceInCache(updateEntity: T, cache: MutableList<T>) {
        var index = 0
        for (entity in cache) {
            if (entity.readLink.equals(updateEntity.readLink)) {
                if (orderByProperty != null) {
                    cache.removeAt(index)
                    insertOrderByProperty(updateEntity, cache)
                } else {
                    cache[index] = updateEntity
                }
                break
            }
            index++
        }
    }

    /**
     * Remove the specified entity from cache
     * Note: implementation should be optimized to obtain better than linear scaling for very large collection
     *
     * @param deleteEntity - deleted entity to be removed from cache
     * @param cache
     */
    protected fun removeFromCache(deleteEntity: T, cache: MutableList<T>) {
        var index = 0
        for (entity in cache) {
            if (entity.readLink.equals(deleteEntity.readLink)) {
                cache.removeAt(index)
                break
            }
            index++
        }
    }

    /**
     * Insert the new entity into the cache list based on list is sorted in ascending order
     * It is possible that we have a null for the value of the order by property. In that case
     * we will assign a default string.
     *
     * @param entity to insert
     * @param cache
     */
    private fun insertOrderByProperty(entity: T, cache: MutableList<T>) {
        val propertyValue = entity.getDataValue(orderByProperty!!)
        var insertOrderByPropertyString = " "
        var listOrderByPropertyString: String

        if (propertyValue != null) {
            insertOrderByPropertyString = propertyValue.toString()
        }

        for ((index, listEntity) in cache.withIndex()) {
            listOrderByPropertyString = if (listEntity.getDataValue(orderByProperty) == null) {
                " "
            } else {
                listEntity.getDataValue(orderByProperty).toString()
            }
            if (insertOrderByPropertyString < listOrderByPropertyString) {
                cache.add(index, entity)
                return
            }
        }
        cache.add(entity)
    }

    /**
     * Repository provides an empty data list, but the in-memory cache is retained. Calling
     * read clears the cache, as well.
     */
    fun clear() {
        observableEntities.value = ArrayList()
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(Repository::class.java)
    }
}
