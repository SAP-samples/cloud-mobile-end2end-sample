package com.sap.mobile.mahlwerk.repository

import android.os.Handler
import android.os.Looper
import com.sap.cloud.android.odata.odataservice.Job
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.odata.DataQuery
import com.sap.cloud.mobile.odata.SortOrder
import com.sap.cloud.mobile.odata.offline.OfflineODataDefiningQuery
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.cloud.mobile.odata.offline.OfflineODataProvider
import com.sap.cloud.mobile.odata.offline.OfflineODataRequestOptions
import com.sap.mobile.mahlwerk.extension.jobStatus
import com.sap.mobile.mahlwerk.extension.taskStatus

/**
 * Repository for tasks
 */
class TaskRepository(odataService: OdataService) : Repository<Task>(
    odataService,
    OdataServiceMetadata.EntitySets.taskSet,
    Task.taskStatusID, SortOrder.DESCENDING
) {

    /**
     * Changes the status of a task to the next status
     * @param task the task to change the status
     * @param successHandler called on success
     * @param failureHandler called on a failure
     */
    fun changeStatus(
        task: Task,
        successHandler: () -> Unit,
        failureHandler: (OfflineODataException) -> Unit
    ) {
        task.taskStatusID = task.taskStatus.nextStatusID
        odataService.updateEntity(task)

        val provider = odataService.provider as? OfflineODataProvider
        provider?.upload(
            arrayOf(OfflineODataRequestOptions.UploadCategory(task)),
            successHandler,
            failureHandler
        )
    }

    /**
     * Changes the status of a job to the next status
     */
    fun changeStatus(job: Job) {
        job.jobStatusID = job.jobStatus.nextStatusID
        odataService.updateEntity(job)
    }

    fun addSuggestedJob(job: Job) {
        job.suggested = false
        odataService.updateEntity(job)
    }

    /**
     * Returns the task after refreshing it with the online database
     * @param task the task to get the live value
     * @param successHandler called on success with the updated task
     * @param failureHandler called on a failure
     */
    fun getLiveValue(
        task: Task,
        successHandler: (Task?) -> Unit,
        failureHandler: (OfflineODataException) -> Unit
    ) {
        val query = listOf(
            OfflineODataDefiningQuery(
                "TaskSet",
                "/TaskSet?\$filter=TaskID eq ${task.taskID}",
                false
            )
        )

        val odataProvider = odataService.provider as? OfflineODataProvider
        odataProvider?.download(query, {
            Handler(Looper.getMainLooper()).post {
                val readTask = read(task)
                successHandler(readTask)
            }
        }, failureHandler)
    }

    /**
     * Reads the task from the repository after finishing the download
     * @param task the task to perform the read
     */
    private fun read(task: Task): Task? {
        val dataQuery = DataQuery()
            .from(OdataServiceMetadata.EntitySets.taskSet)
            .filter(Task.taskID.equal(task.taskID))

        val result = odataService.executeQuery(dataQuery)
        var taskRead = this.convert(result.entityList).firstOrNull()

        if (taskRead != null && taskRead.taskStatusID != 0L) {
            taskRead = null
        }

        if (taskRead == null) {
            removeFromCache(task, entities)
        }

        return taskRead
    }
}