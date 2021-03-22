package com.sap.mobile.mahlwerk.viewmodel

import android.app.Application
import androidx.lifecycle.MutableLiveData
import com.sap.cloud.android.odata.odataservice.OdataService
import com.sap.cloud.android.odata.odataservice.OdataServiceMetadata
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.fiori.maps.FioriMarkerOptions
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.mobile.mahlwerk.repository.TaskRepository

/**
 * ViewModel used for the map screen
 */
class MapViewModel(
    application: Application,
    odataService: OdataService
) : ViewModel(application, odataService) {
    /** Repository containing all tasks */
    private val taskRepository = mahlwerkApplication.repositoryFactory
        .getRepository(OdataServiceMetadata.EntitySets.taskSet) as TaskRepository

    /** Stores all marker on the map in a task map */
    val marker = mutableMapOf<Task, FioriMarkerOptions>()

    /** The recent selected task on the map */
    val selectedTask = MutableLiveData<Task>()

    /** Taks of the repository as live data */
    val tasks = taskRepository.observableEntities

    override fun refresh() {
        taskRepository.read()
    }

    override fun initialRead() {
        initialRead(taskRepository)
    }

    /**
     * Changes the status of an open task to scheduled
     *
     * @param task the task to change
     * @param failureHandler called on a failure
     */
    fun onChangeStatus(task: Task, failureHandler: (OfflineODataException) -> Unit) {
        taskRepository.changeStatus(task, {
            tasks.value = tasks.value
        }, failureHandler)
    }
}