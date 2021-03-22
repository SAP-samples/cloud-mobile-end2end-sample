package com.sap.mobile.mahlwerk.app

import android.content.Context
import android.util.Patterns
import com.sap.cloud.mobile.foundation.configurationprovider.ConfigurationLoader
import com.sap.cloud.mobile.foundation.configurationprovider.ConfigurationPersistenceException
import com.sap.cloud.mobile.foundation.configurationprovider.DefaultPersistenceMethod
import com.sap.mobile.mahlwerk.R
import org.json.JSONException

/**
* Central unsecured configuration data class, which contains all of the entries provided by the [ConfigurationLoader].
* It is loaded once and then accessed by the modules that need it's data.
*/
class ConfigurationData(private val applicationContext: Context, private val errorHandler: ErrorHandler) {

    /** A variable representing whether or not the configuration has been successfully loaded. */
    var isLoaded = false
        private set

    /** A variable representing the Service URL. */
    var serviceUrl: String? = null
        private set

    init {
        resetData()
    }

    /**
     * Loads the cofiguration data from the persistent store. The data was deposited by the [ConfigurationLoader].
     *
     * First, [loadData] tries to get the the Persisted configuration and if the the configuration is not empty it
     * proceeds. When the configuration contains the [KEY_SERVICE_URL] set the [serviceUrl] in other case set it to a
     * default one. Finally, validate the [serviceUrl] and set it to empty in case of failure.
     *
     * @return a boolean value representing whether or not the data was successfully loaded.
     */
    fun loadData(): Boolean {
        val resources = applicationContext.resources
        val errorMsgTitle = resources.getString(R.string.config_data_error_title)
        isLoaded = false

        try {
            val configData = DefaultPersistenceMethod.getPersistedConfiguration(applicationContext)

            if (configData.length() == 0) {
                errorHandler.sendErrorMessage(
                    ErrorMessage(
                        errorMsgTitle,
                        resources.getString(R.string.config_data_no_data_description)
                    )
                )
            } else {
                when (configData.has(KEY_SERVICE_URL)) {
                    true -> serviceUrl = configData.getString(KEY_SERVICE_URL)
                    false -> serviceUrl = String.format(
                        SERVICE_URL_FORMAT,
                        configData.getString(KEY_DISC_SVC_DFLT_PROTOCOL),
                        configData.getString(KEY_DISC_SVC_DFLT_HOST),
                        configData.getString(KEY_DISC_SVC_DFLT_PORT)
                    )
                }

                // Validate serviceUrl
                if (Patterns.WEB_URL.matcher(serviceUrl).matches()) {
                    isLoaded = true
                } else {
                    errorHandler.sendErrorMessage(
                        ErrorMessage(
                            errorMsgTitle,
                            String.format(
                                resources.getString(R.string.config_data_bad_service_url_description),
                                serviceUrl
                            )
                        )
                    )
                    serviceUrl = null
                    isLoaded = false
                }
            }
        } catch (e: ConfigurationPersistenceException) {
            errorHandler.sendErrorMessage(
                ErrorMessage(
                    errorMsgTitle,
                    resources.getString(R.string.config_data_build_json_description),
                    e,
                    false
                )
            )
        } catch (e: JSONException) {
            errorHandler.sendErrorMessage(
                ErrorMessage(
                    errorMsgTitle,
                    resources.getString(R.string.config_data_bad_field_description),
                    e,
                    false
                )
            )
        }
        return isLoaded
    }

    /** Clears all volatile and persisted configurations that was loaded. */
    fun resetConfigurations(context: Context) {
        resetPersistedConfiguration(context)
        resetData()
    }

    /** Resets all of the configuration fields to the unloaded state. */
    fun resetData() {
        isLoaded = false
        serviceUrl = null
    }


    companion object {
        // Define the Keys for the JSON Configuration Data
        private const val KEY_SERVICE_URL = "ServiceUrl"
        private const val SERVICE_URL_FORMAT = "%s://%s:%s/"
        private const val KEY_DISC_SVC_DFLT_PROTOCOL = "protocol"
        private const val KEY_DISC_SVC_DFLT_HOST = "host"
        private const val KEY_DISC_SVC_DFLT_PORT = "port"

        /**
         * Resets the underlying persisted data
         *
         * @param [context] reference to the application context
         */
         @JvmStatic fun resetPersistedConfiguration(context: Context) {
            DefaultPersistenceMethod.resetPersistedConfiguration(context)
        }
    }
}