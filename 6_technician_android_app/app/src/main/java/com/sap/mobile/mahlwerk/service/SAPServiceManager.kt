package com.sap.mobile.mahlwerk.service

import android.content.Context
import android.preference.PreferenceManager
import android.util.Base64
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.mobile.mahlwerk.app.ConfigurationData
import com.sap.mobile.mahlwerk.app.ErrorHandler
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import com.sap.mobile.mahlwerk.offline.OfflineODataSyncService
import com.sap.cloud.mobile.foundation.common.ClientProvider
import com.sap.cloud.mobile.foundation.common.EncryptionUtil
import com.sap.cloud.mobile.odata.core.Action0
import com.sap.cloud.mobile.odata.core.Action1
import com.sap.cloud.mobile.odata.core.AndroidSystem
import com.sap.cloud.mobile.odata.offline.OfflineODataDefiningQuery
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.cloud.mobile.odata.offline.OfflineODataParameters
import com.sap.cloud.mobile.odata.offline.OfflineODataProvider
import com.sap.mobile.mahlwerk.R
import org.slf4j.LoggerFactory
import java.net.URL
import java.util.*

/**
 * This class represents the Mobile Application backed by an OData service for offline use.
 *
 * @param [configurationData] Configuration data from Config Provider
 * @param [context] Application context for use by OfflineProvider
 * @param [errorHandler] Error Handler to report initialization errors
 */
class SAPServiceManager(
    private val configurationData: ConfigurationData,
    private val context: Context,
    private val errorHandler: ErrorHandler) {

    /*
     * Offline line OData Provider
     */
    private var provider: OfflineODataProvider? = null

    internal var application: MahlwerkApplication = context as MahlwerkApplication


    /** Service root-- OData service proxy to interact with local offline OData provider */
    var serviceRoot: String = ""
        private set
        get() {
            return configurationData.serviceUrl + CONNECTION_ID_ODATASERVICE + "/"
        }


    /** OData service for interacting with local OData Provider */
    var odataService: OdataService? = null
        private set
        get() {
            return field ?: throw IllegalStateException("SAPServiceManager was not initialized")
        }

    /**
     * This call can only be made when the user is authenticated (if required) as it depends
     * on application store for encryption keys and ClientProvider
     * @return OfflineODataProvider
     */
    fun retrieveProvider(): OfflineODataProvider? {
        if (provider == null) {
            initializeOffline(false)
        }
        return provider
    }

    /*
     * Create OfflineODataProvider
     * This is a blocking call, no data will be transferred until open, download, upload
     * @param forReset true initializing the offline provider for reset purpose. This is because reset can occur
     * when we have not been onboarded.
     */
    private fun initializeOffline(forReset: Boolean) {
        AndroidSystem.setContext(context)
        var serviceUrl = configurationData.serviceUrl
        if (serviceUrl == null) {
            if (forReset) {
                serviceUrl = "http://localhost/"
            } else {
                LOGGER.error("ServerURL is null when attempting to create offline provider")
            }

        }
        try {
            val offlineODataParameters = OfflineODataParameters()
            offlineODataParameters.isEnableRepeatableRequests = true
            offlineODataParameters.storeName = OFFLINE_DATASTORE
            val encryptionKeyBytes = EncryptionUtil.getEncryptionKey(OFFLINE_DATASTORE_ENCRYPTION_KEY_ALIAS)
            val key = Base64.encodeToString(encryptionKeyBytes, Base64.NO_WRAP)
            offlineODataParameters.storeEncryptionKey = key
            Arrays.fill(encryptionKeyBytes, 0.toByte())

            provider = OfflineODataProvider(
                URL(serviceUrl!! + CONNECTION_ID_ODATASERVICE),
                offlineODataParameters,
                ClientProvider.get(),
                null,
                null
            ).apply {
                addDefiningQuery(OfflineODataDefiningQuery("AddressSet", "AddressSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("CustomerSet", "CustomerSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("JobSet", "JobSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("MachineSet", "MachineSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("MaterialPositionSet", "MaterialPositionSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("MaterialSet", "MaterialSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("OrderEventsSet", "OrderEventsSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("OrderSet", "OrderSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("StepSet", "StepSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("TaskSet", "TaskSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("ToolPositionSet", "ToolPositionSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("ToolSet", "ToolSet", false))
                addDefiningQuery(OfflineODataDefiningQuery("UserSet", "UserSet", false))
            }

            odataService = OdataService(provider!!)

        } catch (e: Exception) {
            LOGGER.error("Exception encountered setting up offline store: " + e.message)
            val res = context.resources
            val errorMessage = ErrorMessage(res.getString(R.string.offline_provider_error),
                res.getString(R.string.offline_provider_error_detail))
            errorHandler.sendErrorMessage(errorMessage)
        }
    }

    /**
     * Synchronize local offline data store with Server
     * Upload - local changes
     * Download - server changes
     * @param syncService
     * @param syncSuccessHandler
     * @param syncFailureHandler
     */
    fun synchronize(syncService: OfflineODataSyncService, syncSuccessHandler: Action0, syncFailureHandler: Action1<OfflineODataException>) {
        syncService.uploadStore(provider!!,
            Action0 {
                syncService.downloadStore(provider!!,
                    Action0 {
                        application.repositoryFactory.reset()
                        syncSuccessHandler.call()
                    },
                    Action1 { error ->
                        application.repositoryFactory.reset()
                        LOGGER.error("Exception encountered uploading from local store: " + error.message)
                        syncFailureHandler.call(error)
                    })
            },
            Action1 { error ->
                application.repositoryFactory.reset()
                LOGGER.error("Exception encountered downloading to local store: " + error.message)
                syncFailureHandler.call(error)
            })
    }

    /*
     * Close and remove offline data store
     */
    fun reset() {
        try {
            if (provider == null) {
                initializeOffline(true)
            }
            provider!!.clear()
            provider = null
        } catch (e: OfflineODataException) {
            LOGGER.error("Unable to reset Offline Data Store. Encountered exception: " + e.message)
            val res = context.resources
            val errorMessage = ErrorMessage(res.getString(R.string.offline_reset_store_error),
            res.getString(R.string.offline_reset_store_error_detail))
            errorHandler.sendErrorMessage(errorMessage)
        }

        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
        sharedPreferences.edit().clear().commit()
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(SAPServiceManager::class.java)

        /* Name of the offline data file on the application file space */
        private const val OFFLINE_DATASTORE = "OfflineDataStore"
        private const val OFFLINE_DATASTORE_ENCRYPTION_KEY_ALIAS = "Offline_DataStore_EncryptionKey_Alias"

        /*
         * Connection ID of Mobile Application
         */
        const val CONNECTION_ID_ODATASERVICE = "/<Add your Application ID from Mobile Services here>" // keep the forward slash there : /applicationID
    }
}
