package com.sap.mobile.mahlwerk.fragment

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import com.sap.cloud.android.odata.odataservice.Customer
import com.sap.mobile.mahlwerk.extension.setupActionBar
import com.sap.mobile.mahlwerk.screen.CustomerScreen
import kotlinx.android.synthetic.main.fragment_customer.*
import kotlinx.android.synthetic.main.item_header.view.*

/**
 * This fragment displays information about a customer
 */
class CustomerFragment : Fragment(), CustomerScreen {


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(
            com.sap.mobile.mahlwerk.R.layout.fragment_customer,
            container,
            false
        )
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        observeCustomer()
    }

    /**
     * Observes the customer and binds the information to the view
     */
    private fun observeCustomer() {
        mainViewModel.selectedCustomer.observe(this, Observer<Customer> { customer ->
            viewModel.loadProperties(customer, Customer.address)

            setupActionBar(toolbar_customer, customer.companyName)

            profileHeader_customer.headline = customer.name
            profileHeader_customer.description = getString(
                com.sap.mobile.mahlwerk.R.string.emailPhone
            ).format(customer.email, customer.phone)

            view_customer_location.textView_itemHeader.text = getString(
                com.sap.mobile.mahlwerk.R.string.location
            )
            textView_customer_street.text = getString(
                com.sap.mobile.mahlwerk.R.string.streetHouseNumber
            ).format(customer.address.street, customer.address.houseNumber)

            textView_customer_town.text = getString(com.sap.mobile.mahlwerk.R.string.postalCodeTown)
                .format(customer.address.postalCode, customer.address.town)
            textView_customer_country.text = customer.address.country

            val address = customer.address.street + "+" +
                customer.address.houseNumber + ",+" + customer.address.postalCode + "+" +
                customer.address.town + ",+" + customer.address.country

            button_customer_show.setOnClickListener { openInMaps(address, false) }
            button_customer_route.setOnClickListener { openInMaps(address, true) }

        })
    }


    /**
     * Opens the provided address in Google Maps
     *
     * @param address the address to show
     * @param navigation if true, it opens a navigation in google maps
     */
    private fun openInMaps(address: String, navigation: Boolean) {
        val uriString = if (navigation) "google.navigation:" else "geo:0,0?"

        val intent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("${uriString}q=${address}")
        )

        startActivity(intent)
    }
}