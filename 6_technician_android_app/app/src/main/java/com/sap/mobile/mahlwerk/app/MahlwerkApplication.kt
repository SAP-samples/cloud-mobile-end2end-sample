package com.sap.mobile.mahlwerk.app

import android.app.Activity
import android.app.Application
import android.content.Intent
import android.provider.Settings
import android.webkit.CookieManager
import com.sap.cloud.mobile.foundation.authentication.AppLifecycleCallbackHandler
import com.sap.cloud.mobile.foundation.authentication.OAuth2Interceptor
import com.sap.cloud.mobile.foundation.authentication.OAuth2WebViewProcessor
import com.sap.cloud.mobile.foundation.common.ClientProvider
import com.sap.cloud.mobile.foundation.common.SettingsParameters
import com.sap.cloud.mobile.foundation.configurationprovider.ConfigurationLoader
import com.sap.cloud.mobile.foundation.networking.AppHeadersInterceptor
import com.sap.cloud.mobile.foundation.networking.WebkitCookieJar
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.logon.*
import com.sap.mobile.mahlwerk.repository.RepositoryFactory
import com.sap.mobile.mahlwerk.service.SAPServiceManager
import com.sap.mobile.mahlwerk.viewmodel.ViewModelFactory
import okhttp3.OkHttpClient
import org.slf4j.LoggerFactory
import java.net.MalformedURLException
import java.util.concurrent.TimeUnit

/**
 * This class extends the [Application] class. Its purpose is to configure application-wide services such as error
 * handling and data access and provide access to them. It maintains an [AppLifecycleCallbackHandler] instance, as well.
 * By extending the callback's default implementation the application will be able to react on lifecycle events of the
 * contained activities.
 */
class MahlwerkApplication : Application() {

    /** Manages and provides access to OData stores providing data for the app. */
    lateinit var sapServiceManager: SAPServiceManager
        private set

    /** Manages and provides access to secure key-value-stores used to persist settings and user data. */
    lateinit var secureStoreManager: SecureStoreManager
        private set

    /**
     * Manages and provides access to local and server-provided client policies, including but not limited to passcode
     * requirements, retry count during unlocking etc.
     */
    lateinit var clientPolicyManager: ClientPolicyManager
        private set

    /** Global error handler displaying error messages to the user */
    lateinit var errorHandler: ErrorHandler
        private set

    /** Lifecycle observer, listens for foreground-background state changes. */
    private lateinit var lifecycleObserver: LifecycleObserver

    /**
     * Utility class for Log Level
     */
    lateinit var logUtil: LogUtil
        private set

    /** Persistent credential store for [OAuth2Interceptor], which authenticates HTTP sessions. */
    lateinit var oauthTokenStore: SAPOAuthTokenStore
        private set

    /** Provides access to locally persisted configuration that is loaded via [ConfigurationLoader]. */
    lateinit var configurationData: ConfigurationData
        private set

    /** Custom factory that injects ODataService into the view models */
    val viewModelFactory by lazy {
        ViewModelFactory(
            this,
            sapServiceManager.odataService ?: throw IllegalArgumentException(
                "Factory needs ODataService to inject into the view models"
            )
        )
    }

    /** Application-wide RepositoryFactory */
    lateinit var repositoryFactory: RepositoryFactory
        private set

    var isOnboarded: Boolean
        set(value) {
            secureStoreManager.isOnboarded = value
        }
        get() = secureStoreManager.isOnboarded

    var settingsParameters: SettingsParameters? = null
        private set
        get() {
            try {
                val serviceUrl = configurationData.serviceUrl ?: ""
                val deviceId = Settings.Secure.getString(this.contentResolver, Settings.Secure.ANDROID_ID)
                return SettingsParameters(serviceUrl, APPLICATION_ID, deviceId, APPLICATION_VERSION)
            } catch (e: MalformedURLException){
                errorHandler.sendErrorMessage(ErrorMessage(
                    resources.getString(R.string.configuration_invalid),
                    String.format(resources.getString(R.string.configuration_contained_malformed_url), e.message),
                    e,
                    false
                ))
            }
            return null
        }

    override fun onCreate() {
        super.onCreate()
        startErrorHandler()

        secureStoreManager = SecureStoreManager(this)
        configurationData = ConfigurationData(this, errorHandler)

        if(isOnboarded) { 
            configurationData.loadData()
        }

        oauthTokenStore = SAPOAuthTokenStore(secureStoreManager)
        sapServiceManager = SAPServiceManager(configurationData, applicationContext, errorHandler)
        clientPolicyManager = ClientPolicyManager(this)
        lifecycleObserver = LifecycleObserver(secureStoreManager)
        repositoryFactory = RepositoryFactory(sapServiceManager)

        registerLifecycleCallbacks()
        initHttpClient()
        logUtil = LogUtil(this)
    }


    private fun initHttpClient() {
        val deviceId = Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
        val oAuth2Configuration = SAPOAuthConfigProvider.getOAuthConfiguration(this)

        val okHttpClient = OkHttpClient.Builder()
                .addInterceptor(OAuth2Interceptor(OAuth2WebViewProcessor(oAuth2Configuration), oauthTokenStore))
                .addInterceptor(AppHeadersInterceptor(APPLICATION_ID, deviceId, APPLICATION_VERSION))
                .cookieJar(WebkitCookieJar())
                .connectTimeout(30, TimeUnit.SECONDS)
                .build()
        ClientProvider.set(okHttpClient)
    }

    /** Registers the SDK-provided lifecycle callback listener for this application. */
    private fun registerLifecycleCallbacks() {
        registerActivityLifecycleCallbacks(AppLifecycleCallbackHandler.getInstance())
    }

    /** Creates a global error handler shared by all app components and starts its background thread. */
    private fun startErrorHandler() {
        errorHandler = ErrorHandler( "SAPWizardErrorHandler" )
        errorHandler.presenter = ErrorPresenterByNotification(this)
        errorHandler.start()
    }

    /**
     * Clears all user-specific data and configuration from the application, essentially resetting it to its initial
     * state. Restarting the application at the end.
     *
     * @param [activity] Activity from which the request originates
     */
    fun resetApplication(activity: Activity) {
        isOnboarded = false

            clientPolicyManager.resetLogLevelChangeListener()

            secureStoreManager.resetStores()
            configurationData.resetConfigurations(applicationContext)
            clearCookies(activity)
            repositoryFactory.reset()
            sapServiceManager.reset()
            restartApplication(activity)
    }

    /**
     * Asks confirmation from the user if the application data should be reset, and resets the app if the user confirms
     * the prompt.
     */
    fun resetApplicationWithUserConfirmation() {
        val activity = AppLifecycleCallbackHandler.getInstance().activity!!
        Intent(activity, ResetApplicationActivity::class.java).run {
            this.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            activity.startActivity(this)
        }
    }

    /**
     * Clears all cookies, making sure no sessions remain in the HTTP client.
     *
     * @param [activity] Activity from which the request originates
     */
    private fun clearCookies(activity: Activity) {
        val webkitCookieManager = CookieManager.getInstance()

        activity.runOnUiThread {
            webkitCookieManager.removeAllCookies {  success ->
                if (success!!) {
                    LOGGER.info("Cookies are deleted.")
                } else {
                    LOGGER.error("Cookies couldn't be removed!")
                }
            }
        }
    }

    /**
     * Restarts the application by presenting the logon screen.
     *
     * @param [activity] Activity from which the request originates
     */
    private fun restartApplication(activity: Activity) {
        val intent = Intent(activity, LogonActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        activity.startActivity(intent)
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(MahlwerkApplication::class.java)

        /** ID of the Mobile Services endpoint configured for this application. */
        const val APPLICATION_ID = "<Enter your Application ID from Mobile Services here>"

        /** Application version sent to Mobile Services, which may be used to control access from outdated clients. */
        const val APPLICATION_VERSION = "<Enter your Application Version here>"
    }
}
