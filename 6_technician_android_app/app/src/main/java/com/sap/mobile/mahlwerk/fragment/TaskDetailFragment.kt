package com.sap.mobile.mahlwerk.fragment

import android.os.Bundle
import android.view.*
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.odata.offline.OfflineODataException
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.TaskDetailPagerAdapter
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.extension.setupActionBar
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.model.TaskStatus
import com.sap.mobile.mahlwerk.screen.TaskScreen
import kotlinx.android.synthetic.main.fragment_task_detail.*

/**
 * This fragment is the container fragment for the jobs, information and materials of a task
 */
class TaskDetailFragment : Fragment(), TaskScreen {
    /** Status icon shown in the menu bar to change the status of the job */
    private lateinit var statusItem: MenuItem

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_task_detail, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewPager_taskDetail.adapter = TaskDetailPagerAdapter(
            requireContext(),
            childFragmentManager
        )

        tabLayout_taskDetail.setupWithViewPager(viewPager_taskDetail)

        observeTask()
    }

    override fun onPause() {
        super.onPause()
        setHasOptionsMenu(false)
        activity?.invalidateOptionsMenu()
    }

    override fun onCreateOptionsMenu(menu: Menu, menuInflater: MenuInflater) {
        menuInflater.inflate(R.menu.menu_task_detail, menu)
        statusItem = menu.findItem(R.id.menu_taskDetail_status)

        viewModel.selectedTask.observe(this, Observer<Task> { task ->
            statusItem.isVisible = when (task.taskStatus) {
                TaskStatus.Active -> false
                TaskStatus.Scheduled -> true
                TaskStatus.Done -> false
                else -> true
            }

            statusItem.setOnMenuItemClickListener {
                onChangeStatus(task)
                true
            }
        })
    }

    /**
     * Observes the selected task and binds its information to the view
     */
    private fun observeTask() {
        viewModel.selectedTask.observe(this, Observer<Task> { task ->
            setupActionBar(toolbar_taskDetail, task.title)
            viewModel.loadProperties(task, Task.machine, Task.job)

            val predictedTime = task.job.sumByDouble { it.predictedWorkHours.toDouble() }
            objectHeader_taskDetail.headline = getString(R.string.machine).format(task.machine.name)
            objectHeader_taskDetail.subheadline = getString(R.string.predictedTime).format(predictedTime)
            objectHeader_taskDetail.setTag(
                getString(R.string.status, task.taskStatus.getLocalizedString(requireContext())),
                0
            )

            if (task.taskStatus == TaskStatus.Done) {
                requireActivity().invalidateOptionsMenu()
            }
        })
    }

    /**
     * Changes the status of the task to the next status
     *
     * @param task the task to change the status
     */
    private fun onChangeStatus(task: Task) {
        val nextStatus = task.taskStatus.nextStatus.getLocalizedString(requireContext())

        AlertDialog.Builder(requireContext())
            .setTitle(R.string.changeStatusTitle)
            .setMessage(getString(R.string.changeStatus).format(nextStatus))
            .setPositiveButton(R.string.yes) { _, _ ->
                viewModel.onChangeStatus(task) {
                    onChangeStatusError(it)
                }
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    /**
     * Handles an error that occures when the user tries to change the status of a task
     *
     * @param exception the exception that was thrown
     */
    private fun onChangeStatusError(exception: OfflineODataException) {
        val errorMessage = when (exception.errorCode) {
            1111 -> ErrorMessage(
                getString(R.string.error_taskTaken),
                getString(R.string.error_taskTakenDetail)
            )
            else -> ErrorMessage(
                getString(R.string.error_changeStatus),
                getString(R.string.error_changeStatusDetail)
            )
        }

        mahlwerkApplication.errorHandler.sendErrorMessage(errorMessage)
    }
}
