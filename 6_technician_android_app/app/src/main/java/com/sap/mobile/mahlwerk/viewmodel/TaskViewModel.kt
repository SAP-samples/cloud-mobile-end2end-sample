package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import android.os.Handler
import android.os.Looper
import androidx.lifecycle.MutableLiveData
import com.sap.cloud.android.odata.odataservice.Job
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.mobile.mahlwerk.repository.TaskRepository

/**
 * ViewModel used for the tasks tab
 */
class TaskViewModel(
    application: Application,
    odataService: OdataService
) : ViewModel(application, odataService) {
    /** Repository containing all tasks */
    private val taskRepository = mahlwerkApplication.repositoryFactory
        .getRepository(OdataServiceMetadata.EntitySets.taskSet) as TaskRepository

    /** Tasks of the repository as live data */
    val tasks = taskRepository.observableEntities

    /** The recent selected task in the tasks tab */
    val selectedTask = MutableLiveData<Task>()

    /** The recent selected job in the tasks tab */
    val selectedJob = MutableLiveData<Job>()

    override fun initialRead() {
        initialRead(taskRepository)
    }

    override fun refresh() {
        taskRepository.read()
    }

    /**
     * Returns the task after getting it from the online databse
     */
    fun getLiveValue(
        task: Task,
        successHandler: (Task?) -> Unit,
        failureHandler: (OfflineODataException) -> Unit
    ) {
        taskRepository.getLiveValue(task, {
            taskRepository.read()
            successHandler(it)
        }, {
            taskRepository.read()
            failureHandler(it)
        })
    }

    /**
     * Changes to status of the task to the next status
     */
    fun onChangeStatus(
        task: Task,
        failureHandler: (OfflineODataException) -> Unit
    ) {
        val currentStatus = task.taskStatusID

        taskRepository.changeStatus(task, {
            taskRepository.read()

            Handler(Looper.getMainLooper()).post {
                selectedTask.value = selectedTask.value
            }
        }, {
            Handler(Looper.getMainLooper()).post {
                task.taskStatusID = currentStatus
                failureHandler(it)
            }
        })
    }

    /**
     * Changes to status of the job to the next status
     */
    fun onChangeStatus(job: Job) {
        taskRepository.changeStatus(job)
        selectedJob.value = selectedJob.value
    }

    /**
     * Adds the suggested job to the regular jobs
     */
    fun addSuggestedJob(job: Job) {
        taskRepository.addSuggestedJob(job)
        selectedTask.value = selectedTask.value
    }
}