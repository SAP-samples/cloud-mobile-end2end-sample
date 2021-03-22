package com.sap.mobile.mahlwerk.map

import android.location.Geocoder
import android.os.AsyncTask
import android.os.Handler
import android.os.Looper
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.fiori.maps.FioriMarkerOptions
import com.sap.cloud.mobile.fiori.maps.FioriPoint
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.fragment.MapFragment
import java.io.IOException
import java.util.*

/**
 * AsyncTask that returns the location of a list of tasks as FioriMarkers
 * Updates the marker on the MapFragment on finish
 */
class AddressTask(
    private val mapFragment: MapFragment
) : AsyncTask<Task, Unit, List<Pair<Task, FioriMarkerOptions>>>() {

    /**
     * Gets the location of the addresses of the tasks from the geocoder
     */
    override fun doInBackground(vararg tasks: Task): List<Pair<Task, FioriMarkerOptions>> {
        val geocoder = Geocoder(mapFragment.requireContext(), Locale.getDefault())

        return tasks.mapNotNull {
            try {
                val address = geocoder.getFromLocationName(
                    "${it.address.street} ${it.address.houseNumber}, " +
                        "${it.address.postalCode} ${it.address.town}, ${it.address.country}",
                    1
                ).getOrNull(0) ?: return@mapNotNull null

                val locationPoint = FioriPoint(address.latitude, address.longitude)

                val marker = FioriMarkerOptions.Builder()
                    .point(locationPoint)
                    .title(it.title)
                    .legendTitle(mapFragment.getString(R.string.task))
                    .icon(R.drawable.ic_outline_jobs)
                    .color(it.taskStatus.getColor(mapFragment.requireContext()))
                    .tag(it.taskID)
                    .build()

                Pair(it, marker)
            } catch (e: IOException) {
                // TODO: Error handling
                null
            }
        }
    }

    /**
     * Clears the marker on the map and replaces it with the new ones
     * Performs an extends action on the first call
     */
    override fun onPostExecute(result: List<Pair<Task, FioriMarkerOptions>>?) {
        val initial = mapFragment.viewModel.marker.isEmpty()

        mapFragment.viewModel.marker.forEach {
            mapFragment.actionProvider?.deleteMarker(it.value)
        }

        mapFragment.viewModel.marker.clear()

        result?.forEach { (task, marker) ->
            mapFragment.viewModel.marker[task] = marker
            mapFragment.actionProvider?.addMarker(marker)
        }

        mapFragment.actionProvider?.cluster()

        if (initial) {
            Handler(Looper.getMainLooper()).postDelayed({
                mapFragment.actionProvider?.doExtentsAction()
            }, 150)
        }
    }
}