package com.sap.mobile.mahlwerk.map

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AlertDialog
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.fiori.maps.ActionCell
import com.sap.cloud.mobile.fiori.maps.AnnotationInfoAdapter
import com.sap.cloud.mobile.fiori.maps.MapPreviewPanel
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.fragment.MapFragment
import com.sap.mobile.mahlwerk.model.TaskStatus

/**
 * AnnotationInfoAdapter for the MapFragment
 */
class MapAnnotaionInfoAdapter(private val mapFragment: MapFragment) : AnnotationInfoAdapter {
    override fun getInfo(tag: Any): Any {
        val tasks = mapFragment.viewModel.tasks.value
            ?: throw IllegalStateException("Tasks should not be null" +
                " when marker are added to the map")
        return tasks.first { it.taskID == tag.toString().toLong() }
    }

    override fun onBindView(mapPreviewPanel: MapPreviewPanel, info: Any) {
        val task = info as? Task ?: throw IllegalStateException(
            "Info must contain a task object"
        )

        mapPreviewPanel.setTitle(task.title)
        mapPreviewPanel.objectHeader.headline = mapFragment.getString(R.string.streetHouseNumber)
            .format(task.address.street, task.address.houseNumber)
        mapPreviewPanel.objectHeader.subheadline = mapFragment.getString(R.string.postalCodeTown)
            .format(task.address.postalCode, task.address.town)

        val actionCells = mutableListOf<ActionCell>()

        val openTask = ActionCell(mapFragment.context)
        openTask.setText(mapFragment.getString(R.string.openTask))
        openTask.setIcon(R.drawable.ic_assignment_black_24dp)
        openTask.setOnClickListener {
            mapFragment.mainViewModel.navigateToTaskDetail(task)
        }
        actionCells.add(openTask)

        if (task.taskStatus == TaskStatus.Open) {
            val schedule = ActionCell(mapFragment.context)
            schedule.setText(mapFragment.getString(R.string.schedule))
            schedule.setIcon(R.drawable.ic_schedule_black_24dp)
            schedule.setOnClickListener {
                AlertDialog.Builder(mapFragment.requireContext())
                    .setTitle(R.string.changeStatusTitle)
                    .setMessage(
                        mapFragment.getString(
                            R.string.changeStatus
                        ).format(TaskStatus.Scheduled.name)
                    )
                    .setPositiveButton(R.string.yes) { _, _ ->
                        mapFragment.viewModel.onChangeStatus(task) { onChangeStatusError(it) }
                    }
                    .setNegativeButton(R.string.cancel, null)
                    .show()
            }
            actionCells.add(schedule)
        }

        val address = task.address.street + "+" + task.address.houseNumber + ",+" +
            task.address.postalCode + "+" + task.address.town + ",+" + task.address.country

        val showRoute = ActionCell(mapFragment.context)
        showRoute.setText(mapFragment.getString(R.string.showRoute))
        showRoute.setIcon(R.drawable.ic_map_black_24dp)
        showRoute.setOnClickListener {
            val intent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("google.navigation:q=${address}")
            )
            mapFragment.startActivity(intent)
        }
        actionCells.add(showRoute)

        mapPreviewPanel.setActionCells(*actionCells.toTypedArray())
    }

    /**
     * Handles an error that occures when the user tries to change the status of a task
     *
     * @param exception the exception that was thrown
     */
    private fun onChangeStatusError(exception: OfflineODataException) {
        val errorMessage = when (exception.errorCode) {
            // TODO: Replace with Backend error codes
            1111 -> ErrorMessage(
                mapFragment.getString(R.string.error_taskTaken),
                mapFragment.getString(R.string.error_taskTakenDetail)
            )
            2222 -> ErrorMessage(
                mapFragment.getString(R.string.error_maxActive),
                mapFragment.getString(R.string.error_maxActiveDetail)
            )
            else -> ErrorMessage(
                mapFragment.getString(R.string.error_changeStatus),
                mapFragment.getString(R.string.error_changeStatusDetail)
            )
        }

        mapFragment.mahlwerkApplication.errorHandler.sendErrorMessage(errorMessage)
    }
}