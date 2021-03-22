package fragment

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import com.sap.cloud.android.odata.odataservice.Order
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.extension.jobStatus
import com.sap.mobile.mahlwerk.model.JobStatus
import com.sap.mobile.mahlwerk.screen.TaskScreen
import kotlinx.android.synthetic.main.fragment_task_information.*
import kotlinx.android.synthetic.main.item_header.view.*
import kotlinx.android.synthetic.main.item_task_information.view.*

/**
 * This fragment displays the information of a task in the TaskDetailFragment
 */
class TaskInformationFragment : Fragment(), TaskScreen {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_task_information, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        view_taskInformation_customer.textView_itemTaskInformation.text = getString(
            R.string.customer
        )
        
        view_taskInformation_customer.imageView_itemTaskInformation.setImageResource(
            R.drawable.ic_business_black_24dp
        )

        observeTask()
    }

    /**
     * Observes the selected task and binds its information to the view
     */
    private fun observeTask() {
        viewModel.selectedTask.observe(this, Observer<Task> { task ->
            viewModel.loadProperties(task, Task.address)

            view_taskInformation_location.textView_itemHeader.text = getString(R.string.location)

            textView_taskInformation_street.text = getString(
                R.string.streetHouseNumber
            ).format(task.address.street, task.address.houseNumber)

            textView_taskInformation_town.text = getString(
                R.string.postalCodeTown
            ).format(task.address.postalCode, task.address.town)
            
            textView_taskInformation_country.text = task.address.country
            noteFormCell_taskInformation_notes.value = task.notes

            val visibility = if (task.job.size > 0 && task.job.all {
                    it.jobStatus == JobStatus.Done
                }) {
                View.VISIBLE
            } else {
                View.GONE
            }


            view_taskInformation_customer.setOnClickListener { navigateToCustomer(task) }

            val address = task.address.street + "+" + task.address.houseNumber + ",+" +
                task.address.postalCode + "+" + task.address.town + ",+" + task.address.country

            button_taskInformation_show.setOnClickListener {
                mainViewModel.navigateToMapAndSelectTask(task)
            }

            button_taskInformation_route.setOnClickListener { openInMaps(address) }
        })
    }

    /**
     * Navigates to the CustomerFragment showing the customer associated with the task
     *
     * @param task the displayed task
     */
    private fun navigateToCustomer(task: Task) {
        viewModel.loadProperties(task, Task.order)
        viewModel.loadProperties(task.order, Order.customer)
        mainViewModel.selectedCustomer.value = task.order.customer
        findNavController().navigate(R.id.action_taskDetailFragment_to_customerFragment)
    }


    /**
     * Opens a navigation to the provided address in Google Maps
     *
     * @param address the address to show
     */
    private fun openInMaps(address: String) {
        val intent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("google.navigation:q=${address}")
        )

        startActivity(intent)
    }
}
