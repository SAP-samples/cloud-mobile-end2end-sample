package com.sap.mobile.mahlwerk.offline

import android.app.*
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.sap.cloud.mobile.odata.core.Action0
import com.sap.cloud.mobile.odata.core.Action1
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.cloud.mobile.odata.offline.OfflineODataProvider
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.activity.MainActivity
import org.slf4j.LoggerFactory

/**
 * Android service providing offline OData synchronization: open, upload and download
 * Operation is executed in foreground mode to maximize resiliency
 * Note that there is only one instance of this service and offline operations can only be
 * executed one at a time.
 *
 * OfflineODataProvider sync operations are non blocking and a new thread will be started.
 */
class OfflineODataSyncService : Service() {
    private val lock = Any()
    private var isExecuting = false
    private var callerSuccessHandler: Action0? = null
    private var callerFailureHandler: Action1<OfflineODataException>? = null

    /* This is the object that receives interactions from clients. */
    private val binder = LocalBinder()

    /**
     * Internal completion handlers
     * Route to handlers provided by caller when some housekeeping is done
     */
    private var internalSuccessHandler = Action0 {
        synchronized(lock) {
            LOGGER.debug("Offline sync operation success")
            isExecuting = false
            stopForeground(true)
        }
        callSuccessHandler()
    }

    private var internalFailureHandler = Action1<OfflineODataException> { exception ->
        synchronized(lock) {
            LOGGER.debug("Offline sync operation failed. Exception:" + exception.message)
            isExecuting = false
            stopForeground(true)
        }
        callFailureHandler(exception)
    }

    /**
     * Class for clients to access.  Because we know this service always
     * runs in the same process as its clients, we don't need to deal with
     * IPC.
     */
    inner class LocalBinder : android.os.Binder() {
        val service: OfflineODataSyncService
        get() = this@OfflineODataSyncService
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onBind(intent: Intent): IBinder? {
        return binder
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val action = intent.action
        LOGGER.debug("onStartCommand action:" + action!!)
        return START_NOT_STICKY
    }

    /**
     * Test and set the execution in progress flag
     * In addition, it will start foreground mode
     * This makes sure that we have only one outstanding offline sync operation at a given time
     * @return true if there is active operation and false otherwise
     */
    private fun testAndSetExecutionStatus(): Boolean {
        synchronized(lock) {
            return if (isExecuting) {
                false
            } else {
                isExecuting = true
                LOGGER.debug("Offline sync starting in foreground mode")
                startForeground(NOTIFICATION_ID, createNotification())
                true
            }
        }
    }

    /**
     * Open offline data store. Initial open will incur download of data specified in the defining requests
     * @param provider
     * @param successHandler
     * @param failureHandler
     */
    fun openStore(provider: OfflineODataProvider, successHandler: Action0?, failureHandler: Action1<OfflineODataException>?) {
        if (testAndSetExecutionStatus()) {
            callerSuccessHandler = successHandler
            callerFailureHandler = failureHandler
            LOGGER.debug("Opening offline store")
            provider.open(internalSuccessHandler, internalFailureHandler)
            return
        }
        failureHandler!!.call(OfflineODataException(0, "An offline sync operation is already in progress"))
    }

    /**
     * Download any new changes since last time this is invoked
     * @param provider
     * @param successHandler
     * @param failureHandler
     */
    fun downloadStore(provider: OfflineODataProvider, successHandler: Action0?, failureHandler: Action1<OfflineODataException>?) {
        if (testAndSetExecutionStatus()) {
            callerSuccessHandler = successHandler
            callerFailureHandler = failureHandler
            LOGGER.debug("Downloading offline store")
            provider.download(internalSuccessHandler, internalFailureHandler)
            return
        }
        failureHandler!!.call(OfflineODataException(0, "An offline sync operation is already in progress"))
    }

    /**
     * Upload local changes to OData service
     * @param provider
     * @param successHandler
     * @param failureHandler
     */
    fun uploadStore(provider: OfflineODataProvider, successHandler: Action0?, failureHandler: Action1<OfflineODataException>?) {
        if (testAndSetExecutionStatus()) {
            callerSuccessHandler = successHandler
            callerFailureHandler = failureHandler
            LOGGER.debug("Uploading offline store")
            provider.upload(internalSuccessHandler, internalFailureHandler)
            return
        }
        failureHandler!!.call(OfflineODataException(0, "An offline sync operation is already in progress"))
    }

    private fun callSuccessHandler() {
        callerSuccessHandler?.let {
            callerSuccessHandler!!.call()
        }
    }

    private fun callFailureHandler(exception: OfflineODataException) {
        callerFailureHandler?.let {
            callerFailureHandler!!.call(exception)
        }
    }

    /**
     * Creates persistent notification to put service into foreground mode
     * @return notification
     */
    private fun createNotification(): Notification {
        val builder = NotificationCompat.Builder(this, OFFLINE_SYNC_CHANNEL_ID)
        val bigTextStyle = NotificationCompat.BigTextStyle()

        bigTextStyle.setBigContentTitle("Syncing Data.")
        builder.setStyle(bigTextStyle)
        builder.setWhen(System.currentTimeMillis())
        builder.setSmallIcon(R.drawable.ic_sync)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId(OFFLINE_SYNC_CHANNEL_ID)
        }
        builder.setProgress(100, 0, true)

        // Clicking the notification will return to the app
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, 0)
        builder.setFullScreenIntent(pendingIntent, false)
        return builder.build()
    }

    /**
     * To send notification, Oreo and later versions (API 26+) require a notification channel
     */
    private fun createNotificationChannel() {
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Offline OData Sync"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(OFFLINE_SYNC_CHANNEL_ID, name, importance)

            val notificationManager = getSystemService(NotificationManager::class.java)
            channel.setSound(null, null)
            notificationManager?.createNotificationChannel(channel)
        }
    }

    companion object {
        private val LOGGER = LoggerFactory.getLogger(OfflineODataSyncService::class.java)
        private const val NOTIFICATION_ID = 1
        private const val OFFLINE_SYNC_CHANNEL_ID = "Offline OData Channel"
    }
}
