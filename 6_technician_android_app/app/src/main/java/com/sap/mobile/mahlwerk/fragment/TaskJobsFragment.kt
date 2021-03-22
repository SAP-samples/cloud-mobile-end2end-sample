package com.sap.mobile.mahlwerk.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.JobAdapter
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.model.TaskStatus
import com.sap.mobile.mahlwerk.screen.TaskScreen
import kotlinx.android.synthetic.main.fragment_task_jobs.*
import kotlinx.android.synthetic.main.item_header.view.*

/**
 * This fragment displays the jobs of a task in the TaskDetailFragment
 */
class TaskJobsFragment : Fragment(), TaskScreen {
    /** The adapter holding the jobs of the task */
    private val jobAdapter by lazy {
        JobAdapter(requireContext()).apply {
        }
    }

    /** The adapter holding the suggested jobs of the task */
    private val suggestedJobAdapter by lazy {
        JobAdapter(requireContext()).apply {
            noItemsString = getString(R.string.noItems_suggestedJobs)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_task_jobs, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        view_task_jobs.textView_itemHeader.text = getString(R.string.jobs)
        view_task_suggestedJobs.textView_itemHeader.text = getString(R.string.suggestedJobs)

        recyclerView_task_jobs.adapter = jobAdapter
        recyclerView_task_suggestedJobs.adapter = suggestedJobAdapter

        suggestedJobAdapter.onAddSuggestedJob = { viewModel.addSuggestedJob(it) }
        observeTask()
    }

    /**
     * Observes the selected task and binds its jobs to the view
     */
    private fun observeTask() {
        viewModel.selectedTask.observe(this, Observer<Task> { task ->
            viewModel.loadProperties(task, Task.job)

            jobAdapter.items = task.job.filter { !it.suggested }.toMutableList()
            suggestedJobAdapter.items = task.job.filter { it.suggested }.toMutableList()

            // TODO: Replace with UserID check
            suggestedJobAdapter.isAssigned = task.taskStatus == TaskStatus.Active
                || task.taskStatus == TaskStatus.Scheduled
        })
    }

}
