package com.sap.mobile.mahlwerk.fragment

import android.os.Bundle
import android.view.*
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.navigation.findNavController
import androidx.navigation.fragment.findNavController
import com.sap.cloud.android.odata.odataservice.Order
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.TaskAdapter
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.extension.setupActionBar
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.model.TaskStatus
import com.sap.mobile.mahlwerk.screen.Refreshable
import com.sap.mobile.mahlwerk.screen.TaskScreen
import com.sap.mobile.mahlwerk.util.SearchHandler
import kotlinx.android.synthetic.main.fragment_tasks.*
import kotlinx.android.synthetic.main.item_footer.view.*
import kotlinx.android.synthetic.main.item_header.view.*

/**
 * This fragment provides access to all tasks
 */
class TasksFragment : Fragment(), TaskScreen, Refreshable, SearchHandler {
    /**
     * The Adapter that is holding all tasks that are assigned to the user
     */
    private val myTaskAdapter by lazy {
        TaskAdapter(requireContext()).apply {
            noItemsString = getString(R.string.noItems_myTasks)
            this.onItemClick = { navigateToTaskDetail(it) }
        }
    }

    /**
     * The Adapter that is holding all open tasks
     */
    private val openTaskAdapter by lazy {
        TaskAdapter(requireContext()).apply {
            noItemsString = getString(R.string.noItems_openTasks)
            this.onItemClick = { onSelectOpenTask(it) }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_tasks, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupActionBar(
            toolbar_tasks,
            getString(R.string.tasks),
            R.drawable.ic_account_circle_white_24dp
        )

        setupRefreshLayout(swipeRefreshLayout_tasks, viewModel)

        toolbar_tasks.setNavigationOnClickListener {
            if(findNavController().currentDestination?.id == R.id.tasksFragment){
            findNavController().navigate(R.id.action_tasksFragment_to_profileFragment)}
        }

        view_tasks_myTasks.textView_itemHeader.text = getString(R.string.myTasks)
        view_tasks_openTasks.textView_itemHeader.text = getString(R.string.openTasks)
        view_tasks_history.apply {
            textView_itemFooter.text = getString(R.string.tasksHistory)
            setOnClickListener {
                if(findNavController().currentDestination?.id == R.id.tasksFragment){
                findNavController().navigate(R.id.action_tasksFragment_to_tasksHistoryFragment)}
            }
        }

        recyclerView_tasks_myTasks.adapter = myTaskAdapter
        recyclerView_tasks_openTasks.adapter = openTaskAdapter

        mainViewModel.onSelectTask = {
            viewModel.selectedTask.value = it
        }

        observeTasks()
    }

    override fun onResume() {
        super.onResume()
        viewModel.syncData()
    }

    override fun onPause() {
        super.onPause()
        setHasOptionsMenu(false)
        activity?.invalidateOptionsMenu()
    }

    override fun onCreateOptionsMenu(menu: Menu, menuInflater: MenuInflater) {
        menuInflater.inflate(R.menu.menu_tasks, menu)

        setupSearchView<Task>(
            activity = requireActivity(),
            scrollView = nestedScrollView_tasks,
            menuItem = menu.findItem(R.id.menu_tasks_search),
            recyclerViews = listOf(
                Pair(view_tasks_myTasks, recyclerView_tasks_myTasks),
                Pair(view_tasks_openTasks, recyclerView_tasks_openTasks)
            ),
            viewsToHide = listOf(view_tasks_history)
        )
    }

    /**
     * Observes all tasks and binds its information to the view
     */
    private fun observeTasks() {
        swipeRefreshLayout_tasks.isRefreshing = true

        viewModel.tasks.observe(this, Observer<List<Task>> { tasks ->
            swipeRefreshLayout_tasks.isRefreshing = false

            tasks.forEach {
                viewModel.loadProperties(it, Task.address, Task.order)
                viewModel.loadProperties(it.order, Order.customer)
            }

            myTaskAdapter.items = tasks.filter {
                it.taskStatus == TaskStatus.Active || it.taskStatus == TaskStatus.Scheduled
            }.toMutableList()

            openTaskAdapter.items = tasks.filter {
                it.taskStatus == TaskStatus.Open
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
        if(findNavController().currentDestination?.id == R.id.tasksFragment){
        findNavController().navigate(R.id.action_tasksFragment_to_taskDetailFragment)}
    }

    /**
     * Checks if the open tasks is aleady taken
     * Navigates to the details of the task, if it is is not assigned to another user
     * Performs a download of the task in the foreground
     */
    private fun onSelectOpenTask(task: Task) {
        if(fioriProgressBar_tasks!=null){
        fioriProgressBar_tasks.visibility = View.VISIBLE}

        viewModel.getLiveValue(task, {
            activity?.runOnUiThread {
                if(fioriProgressBar_tasks!=null){
                fioriProgressBar_tasks.visibility = View.GONE}

                if (it != null) {
                    viewModel.selectedTask.value = it
                    if(findNavController().currentDestination?.id == R.id.tasksFragment){
                    findNavController().navigate(R.id.action_tasksFragment_to_taskDetailFragment)}
                } else {
                    val errorMessage = ErrorMessage(
                        getString(R.string.error_taskTaken),
                        getString(R.string.error_taskTakenDetail)
                    )

                    mahlwerkApplication.errorHandler.sendErrorMessage(errorMessage)
                }
            }
        }, {
            val errorMessage = ErrorMessage(
                getString(R.string.read_failed),
                getString(R.string.read_failed_detail)
            )

            mahlwerkApplication.errorHandler.sendErrorMessage(errorMessage)
        })
    }

}
