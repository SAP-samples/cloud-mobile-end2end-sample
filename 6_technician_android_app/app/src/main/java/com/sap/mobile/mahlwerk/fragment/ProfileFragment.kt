package com.sap.mobile.mahlwerk.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.MahlwerkApplication
import com.sap.mobile.mahlwerk.extension.setupActionBar
import com.sap.mobile.mahlwerk.screen.UserScreen
import kotlinx.android.synthetic.main.fragment_profile.*

/**
 * Displays information about the user that is using the app
 */
class ProfileFragment : Fragment(), UserScreen {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_profile, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupActionBar(toolbar_profile, getString(R.string.profile))

        button_profile_signOut.setOnClickListener {
            val activity = requireActivity()
            (activity.application as MahlwerkApplication).resetApplication(activity)
        }

        observeUser()
    }

    /**
     * Observes the user and binds his information to the view
     */
    private fun observeUser() {
        viewModel.users.observe(this, Observer { users ->
            val user = users.find { it.userID == 1L }

            if (user != null) {
                profileHeader_profile.headline = user.firstNames + " " + user.lastNames
                profileHeader_profile.subheadline = getString(R.string.serviceTechnician)
                profileHeader_profile.description = getString(R.string.emailPhone)
                    .format(user.email, user.phone)
            }
        })
    }
}