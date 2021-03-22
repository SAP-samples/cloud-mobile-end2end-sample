package com.sap.mobile.mahlwerk.screen

import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.app.ErrorMessage
import com.sap.mobile.mahlwerk.viewmodel.ViewModel

/**
 * Implements the refresh logic for a refresh layout
 */
interface Refreshable : Screen {

    /**
     * Setup an refresh layout that performs an upload and download of the data
     *
     * @param refreshLayout the view of the SwipeRefreshLayout
     * @param viewModel the view model to be refreshed after the sync
     */
    fun setupRefreshLayout(
        refreshLayout: SwipeRefreshLayout,
        viewModel: ViewModel
    ) {
        refreshLayout.setOnRefreshListener {
            viewModel.syncData({

            }, {
                onError(refreshLayout)
            }, {
                refreshLayout.isRefreshing = false
            })
        }
    }

    /**
     * Handles errors while syncinc the data
     *
     * @param refreshLayout the view of the SwipeRefreshLayout
     */
    private fun onError(refreshLayout: SwipeRefreshLayout) {
        refreshLayout.isRefreshing = false

        val errorMessage = ErrorMessage(
            requireActivity().getString(R.string.read_failed),
            requireActivity().getString(R.string.read_failed_detail)
        )

        mahlwerkApplication.errorHandler.sendErrorMessage(errorMessage)
    }
}