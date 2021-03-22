package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.mobile.odata.DataQuery
import com.sap.cloud.mobile.odata.EntityValue
import com.sap.cloud.mobile.odata.Property
import com.sap.cloud.mobile.odata.core.Action0
import com.sap.cloud.mobile.odata.core.Action1
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.cloud.mobile.odata.offline.OfflineODataProvider
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import com.sap.mobile.mahlwerk.repository.Repository
import org.slf4j.LoggerFactory

/**
 * Generic ViewModel providing basic repository functions
 */
abstract class ViewModel(
    application: Application,
    protected val odataService: OdataService
) : AndroidViewModel(application) {
    /** Indicates if the initial read was already perfomed once */
    private var initialReadDone = false

    /** Convenience property for accessing the MahlwerkApplication */
    protected val mahlwerkApplication = application as? MahlwerkApplication
        ?: throw IllegalStateException("Application must be of type MahlwerkApplication")

    /** Convenience property for accessing the ODataProvider */
    protected val odataProvider = odataService.provider as OfflineODataProvider

    /**
     * Performs the initial read of the repository
     */
    abstract fun initialRead()

    /**
     * Refreshes the repository
     */
    abstract fun refresh()

    /**
     * Performs an upload and then a download
     *
     * @param onSuccess called after success
     */
    fun syncData(
        onSuccess: (() -> Unit)? = null,
        onError: ((OfflineODataException) -> Unit)? = null,
        onFinish: (() -> Unit)? = null
    ) {
        odataProvider.upload({
            odataProvider.download({
                refresh()
                onSuccess?.invoke()
                onFinish?.invoke()
            }, {
                onError?.invoke(it)
                onFinish?.invoke()
                LOGGER.warn(it.message)
            })
        }, {
            onError?.invoke(it)
            onFinish?.invoke()
            LOGGER.warn(it.message)
        })
    }

    /**
     * Convinience funtion to load properties from an EntityValue
     *
     * @param into the EntitiyValue to load the property from / to
     * @param properties the properties to load
     * @param query optional query to perform while loading the properties
     */
    fun loadProperties(
        into: EntityValue,
        vararg properties: Property,
        query: DataQuery? = null
    ) {
        properties.forEach {
            odataService.loadProperty(it, into, query)
        }
    }

    /**
     * Performs the initial read of the repository
     * Does nothing if the initial read was already performed
     *
     * @param repository the repository to perform the initial read
     */
    protected fun initialRead(repository: Repository<out EntityValue>) {
        if (initialReadDone) {
            return
        }

        repository.initialRead(
            Action0 { initialReadDone = true },
            Action1 { error ->
                initialReadDone = false
                val errorHandler = (getApplication<Application>() as MahlwerkApplication).errorHandler
                val resources = getApplication<Application>().resources
                val errorMessage = ErrorMessage(
                    resources.getString(R.string.read_failed),
                    resources.getString(R.string.read_failed_detail), error, false
                )
                errorHandler.sendErrorMessage(errorMessage)
            }
        )
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(ViewModel::class.java)
    }
}