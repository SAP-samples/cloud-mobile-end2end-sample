package com.sap.mobile.mahlwerk.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap.*
import com.google.android.gms.maps.model.LatLng
import com.sap.cloud.android.odata.odataservice.Task
import com.sap.cloud.mobile.fiori.formcell.ChoiceFormCell
import com.sap.cloud.mobile.fiori.formcell.FormCell
import com.sap.cloud.mobile.fiori.maps.*
import com.sap.cloud.mobile.fiori.maps.google.GoogleFioriMapView
import com.sap.cloud.mobile.fiori.maps.google.GoogleMapActionProvider
import com.sap.mobile.mahlwerk.R
import com.sap.mobile.mahlwerk.adapter.MapResultsAdapter
import com.sap.mobile.mahlwerk.extension.hideKeyboard
import com.sap.mobile.mahlwerk.extension.taskStatus
import com.sap.mobile.mahlwerk.map.AddressTask
import com.sap.mobile.mahlwerk.map.MapAnnotaionInfoAdapter
import com.sap.mobile.mahlwerk.model.TaskStatus
import com.sap.mobile.mahlwerk.screen.MapScreen
import kotlinx.android.synthetic.main.fragment_map.*

/**
 * This fragment displays the task in a map
 */
class MapFragment : Fragment(), MapScreen, GoogleFioriMapView.OnMapCreatedListener {
    /** Indicates if the list of tasks is displayed in fullscreen */
    private var isContentPanelFullscreen = false

    /** The ActionProvider of the map */
    var actionProvider: GoogleMapActionProvider? = null

    /** The Adapter containing the tasks in the list of the sheet over the map */
    private val mapResultsAdapter by lazy {
        MapResultsAdapter(requireContext()).apply {
            onItemClick = { onSelectTask(it) }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_map, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        googleFioriMapView.onCreate(savedInstanceState)
        googleFioriMapView.setOnMapCreatedListener(this)

        @SuppressLint("InflateParams")
        val settingsView = layoutInflater.inflate(R.layout.fragment_settings, null)

        // Setup selection of a different map type
        val mapTypeChoice = settingsView.findViewById<ChoiceFormCell>(R.id.map_type)
        mapTypeChoice.valueOptions = arrayOf(
            getString(R.string.mapTypeNormal),
            getString(R.string.mapTypeSatellite),
            getString(R.string.mapTypeTerrain),
            getString(R.string.mapTypeHybrid)
        )
        mapTypeChoice.cellValueChangeListener = object : FormCell.CellValueChangeListener<Int>() {
            public override fun cellChangeHandler(value: Int?) {
                when (value) {
                    0 -> googleFioriMapView.map?.mapType = MAP_TYPE_NORMAL
                    1 -> googleFioriMapView.map?.mapType = MAP_TYPE_SATELLITE
                    2 -> googleFioriMapView.map?.mapType = MAP_TYPE_TERRAIN
                    3 -> googleFioriMapView.map?.mapType = MAP_TYPE_HYBRID
                }
            }
        }

        // Select the current mapType in the settings panel
        val mapType = googleFioriMapView.map?.mapType ?: 0
        mapTypeChoice.value = if (mapType == 0) 0 else mapType - 1

        googleFioriMapView.setSettingsView(settingsView)
        googleFioriMapView.setGeometryItems(listOf())
        googleFioriMapView.setDefaultPanelContent(googleFioriMapView.mapListPanel)

        mainViewModel.onSelectMapTask = {
            viewModel.selectedTask.value = it
            actionProvider?.selectMarker(viewModel.marker[it])
        }

        setMapListPanel()
        observeTasks()
    }

    override fun onMapCreated() {
        actionProvider = GoogleMapActionProvider(googleFioriMapView, this)

        val buttons = listOf(
            SettingsButton(googleFioriMapView.toolbar.context),
            LegendButton(googleFioriMapView.toolbar.context),
            LocationButton(googleFioriMapView.toolbar.context),
            ZoomExtentButton(googleFioriMapView.toolbar.context)
        )

        googleFioriMapView.toolbar.addButtons(buttons)

        val walldorf = LatLng(49.306370, 8.642769)
        googleFioriMapView.map?.moveCamera(CameraUpdateFactory.newLatLngZoom(walldorf, 12f))

        actionProvider?.annotationInfoAdapter = MapAnnotaionInfoAdapter(this)
        setupSearchView()
    }

    override fun onStart() {
        super.onStart()
        googleFioriMapView.onStart()
    }

    override fun onResume() {
        super.onResume()
        googleFioriMapView.onResume()

        val activity = activity as? AppCompatActivity
        activity?.supportActionBar?.hide()
        activity?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)

        viewModel.syncData()
    }

    override fun onPause() {
        super.onPause()
        googleFioriMapView.onPause()

        val activity = activity as? AppCompatActivity
        activity?.supportActionBar?.show()
        activity?.window?.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
    }

    override fun onStop() {
        super.onStop()
        googleFioriMapView?.onStop()
    }

    override fun onDestroy() {
        super.onDestroy()
        googleFioriMapView?.onDestroy()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        googleFioriMapView.onSaveInstanceState(outState)
    }

    override fun onLowMemory() {
        super.onLowMemory()
        googleFioriMapView.onLowMemory()
    }

    /**
     * Observes all tasks and binds its information to the view
     */
    private fun observeTasks() {
        viewModel.tasks.observe(this, Observer<List<Task>> {
            val tasks = it.filter { task ->
                viewModel.loadProperties(task, Task.address)
                task.taskStatus != TaskStatus.Done
            }.toMutableList()

            AddressTask(this).execute(*tasks.toTypedArray())
            mapResultsAdapter.items = tasks
        })
    }

    /**
     * Selects the marker on the map
     * If the content panel is fullscreen, it hides the content panel and selects it afterwards
     *
     * @param task the task that was selected on the map
     */
    private fun onSelectTask(task: Task) {
        viewModel.selectedTask.value = task

        if (isContentPanelFullscreen) {
            googleFioriMapView.hideContentPanel()
            isContentPanelFullscreen = false
            activity?.hideKeyboard()

            Handler(Looper.getMainLooper()).postDelayed({
                actionProvider?.selectMarker(viewModel.marker[task])
                googleFioriMapView.showContentPanel(false)
            }, 500)
        } else {
            actionProvider?.selectMarker(viewModel.marker[task])
        }
    }

    /**
     * Setup the ListAdapter of the list of tasks in the sheet over the map
     */
    private fun setMapListPanel() {
        googleFioriMapView.mapListPanel.apply {
            setAdapter(mapResultsAdapter)
            getFilterFormCell().apply {
                setValueOptions(arrayOf(
                    getString(R.string.status_open),
                    getString(R.string.status_scheduled),
                    getString(R.string.status_active))
                )
                value = listOf(0, 1, 2)
                cellValueChangeListener = object : FormCell.CellValueChangeListener<List<Int>>() {
                    override fun cellChangeHandler(value: List<Int>?) {
                        val values = value?.map { TaskStatus.values()[it] }
                        mapResultsAdapter.setFilterValues(values)
                    }
                }
            }
        }
    }

    /**
     * Setup the SearchView to filter the list of tasks in the sheet over the map while searching
     */
    private fun setupSearchView() {
        val searchView = view?.findViewById<FioriMapSearchView>(
            R.id.fiori_map_search_view
        )

        searchView?.setOnQueryTextListener(
            object : androidx.appcompat.widget.SearchView.OnQueryTextListener {
                override fun onQueryTextSubmit(query: String?): Boolean {
                    activity?.hideKeyboard()
                    return true
                }

                override fun onQueryTextChange(newText: String?): Boolean {
                    mapResultsAdapter.filter(newText ?: "")
                    return true
                }
            }
        )

        searchView?.setOnQueryTextFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                googleFioriMapView.showContentPanel(true)
                isContentPanelFullscreen = true
            }
        }
    }
}