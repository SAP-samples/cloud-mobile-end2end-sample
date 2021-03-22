package com.sap.mobile.mahlwerk.fragment

import android.os.Bundle
import android.view.*
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.TaskAdapter
import com.sap.mobile.mahlwerk.extension.setupActionBar
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.model.TaskStatus
import com.sap.mobile.mahlwerk.screen.TaskScreen
import com.sap.mobile.mahlwerk.util.SearchHandler
import kotlinx.android.synthetic.main.fragment_tasks_history.*
import kotlinx.android.synthetic.main.item_header.view.*

/**
 * This fragment displays all finished tasks in a list
 */
class TasksHistoryFragment : Fragment(), TaskScreen, SearchHandler {
    private val historyAdapter by lazy {
        TaskAdapter(requireContext()).apply {
            noItemsString = getString(R.string.noItems_historyTasks)
            onItemClick = { navigateToTaskDetail(it) }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_tasks_history, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupActionBar(toolbar_tasksHistory, getString(R.string.tasksHistory))

        view_tasksHistory_history.textView_itemHeader.text = getString(R.string.tasksHistory)

        val divider = DividerItemDecoration(context, DividerItemDecoration.VERTICAL)

        recyclerView_tasksHistory.apply {
            isNestedScrollingEnabled = false
            addItemDecoration(divider)
            layoutManager = LinearLayoutManager(context)
            adapter = historyAdapter
        }

        observeTask()
    }

    override fun onPause() {
        super.onPause()
        setHasOptionsMenu(false)
        activity?.invalidateOptionsMenu()
    }

    override fun onCreateOptionsMenu(menu: Menu, menuInflater: MenuInflater) {
        menuInflater.inflate(R.menu.menu_task_history, menu)

        setupSearchView<Task>(
            activity = requireActivity(),
            scrollView = nestedScrollView_tasksHistory,
            menuItem = menu.findItem(R.id.menu_tasksHistory_search),
            recyclerViews = listOf(Pair(view_tasksHistory_history, recyclerView_tasksHistory))
        )
    }

    /**
     * Observes all tasks and binds the finished tasks to the view
     */
    private fun observeTask() {
        viewModel.tasks.observe(this, Observer<List<Task>> { tasks ->
            historyAdapter.items = tasks.filter {
                it.taskStatus == TaskStatus.Done
            }.toMutableList()
        })
    }

    /**
     * Navigates to the TaskDetailFragment and displays the details of the task
     *
     * @param task the task to display the details
     */
    private fun navigateToTaskDetail(task: Task) {
        viewModel.selectedTask.value = task
        findNavController().navigate(R.id.action_tasksHistoryFragment_to_taskDetailFragment)
    }
}
