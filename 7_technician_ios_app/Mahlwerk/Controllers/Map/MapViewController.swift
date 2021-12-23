//
//  MapViewController.swift
//  Design-Controls
//
//  Created by Kuck, Robin on 16.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import MapKit
import SAPFiori
import CoreLocation
import SAPOfflineOData
import SAPFioriFlows

struct TaskAnnotation {
    var annotation: MKPointAnnotation
    var task: Task
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: FUIMKMapView!
    var mapToolbar: FUIMapToolbar!
    
    let visibleMeters = 2000.0
    var isSearching = false
    var isDetailShown = false
    var showDetailPanel = true
    var detailPanel: FUIMapDetailPanel!
    
    var tasks = [Task]() {
        didSet {
            tasks.sort(by: { (a, b) -> Bool in
                a.taskStatusID! > b.taskStatusID!
            })
        }
    }
    var taskAnnotations = [TaskAnnotation]()
    var filteredTaskAnnotations = [TaskAnnotation]()
    
    var odataService : OdataService<OfflineODataProvider>?
    
    var contentObject: MapDetailPanelContentControllerObject! {
        didSet {
            detailPanel.content.tableView.dataSource = contentObject
            detailPanel.content.tableView.delegate = contentObject
            detailPanel.content.tableView.reloadData()
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        self.odataService = odataService
        
        mapToolbar = FUIMapToolbar(mapView: mapView)
        
        DispatchQueue.global(qos: .background).async {
            self.addAnnotations()
        }
        
        setupDetailPanel()
        setupToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // present panel when map view appears
        if showDetailPanel {
            self.detailPanel.presentContainer()
        }
        setupLocationServices()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // dismiss detail panel when map view disappears
        if showDetailPanel {
            presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: false) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupDetailPanel() {
        detailPanel = FUIMapDetailPanel(parentViewController: self, mapView: mapView)
        
        detailPanel.searchResults.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        
        detailPanel.isSearchEnabled = true
        detailPanel.searchResults.tableView.dataSource = self
        detailPanel.searchResults.tableView.delegate = self
        detailPanel.searchResults.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        detailPanel.searchResults.searchBar.delegate = self
        
        detailPanel.content.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier:
            FUIObjectTableViewCell.reuseIdentifier)
        detailPanel.content.tableView.register(FUIMapDetailPanel.ButtonTableViewCell.self, forCellReuseIdentifier:
            FUIMapDetailPanel.ButtonTableViewCell.reuseIdentifier)
        detailPanel.content.tableView.register(FUIMapDetailPanel.ActionTableViewCell.self, forCellReuseIdentifier:
            FUIMapDetailPanel.ActionTableViewCell.reuseIdentifier)
    }
    
    private func setupToolbar() {
        let toolbar = FUIMapToolbar(mapView: mapView)
        let locationButton = FUIMapToolbar.UserLocationButton(mapView: mapView)
        let zoomButton = FUIMapToolbar.ZoomExtentButton(mapView: mapView)
        
        toolbar.items = [locationButton, zoomButton]
    }
    
    private func setupLocationServices() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotations() {
        if taskAnnotations.count > 0 {
            taskAnnotations = []
            self.mapView.removeAnnotations(mapView.annotations)
        }
        let tasks = self.tasks.filter { (task) -> Bool in
            task.taskStatusID != TaskStatus.done.id
        }
        var count = tasks.count
        
        tasks.forEach { (task) in
            let geoCoder = CLGeocoder()
            if let address = task.address {
                let addressString = "\(address.street ?? "") \(address.houseNumber ?? ""), \(address.postalCode ?? "") \(address.town ?? "")"
                geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
                    if error == nil {
                        if let placemark = placemarks?[0] {
                            let location = placemark.location!
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location.coordinate
                            annotation.title = task.title
                            annotation.subtitle = addressString
                            self.mapView.addAnnotation(annotation)
                            self.taskAnnotations.append(TaskAnnotation(annotation: annotation, task: task))
                        }
                    }
                    
                    count -= 1
                    if count == 0 {
                        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        self.detailPanel.searchResults.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func displayTask(task: Task) {
        let geoCoder = CLGeocoder()
        let addressString = "\(task.address!.street ?? "") \(task.address!.houseNumber ?? ""), \(task.address!.postalCode ?? "") \(task.address!.town ?? "")"
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = task.title
                    annotation.subtitle = addressString
                    self.mapView.addAnnotation(annotation)
                    self.taskAnnotations.append(TaskAnnotation(annotation: annotation, task: task))
                    self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: self.visibleMeters, longitudinalMeters: self.visibleMeters), animated: false)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func displaySingleLocation(address: Address, title: String) {
        let geoCoder = CLGeocoder()
        let addressString = "\(address.street ?? "") \(address.houseNumber ?? ""), \(address.postalCode ?? "") \(address.town ?? "")"
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = title
                    annotation.subtitle = addressString
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: self.visibleMeters, longitudinalMeters: self.visibleMeters), animated: false)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    internal func selectTaskAnnotation(task: Task, annotation: MKPointAnnotation) {
        self.mapView.selectAnnotation(annotation, animated: true)
        contentObject = MapDetailPanelContentControllerObject(task: task, coordinate: annotation.coordinate, viewController: self)
        detailPanel.content.headlineText = contentObject.headlineText
        detailPanel.content.subheadlineText = contentObject.subheadlineText
        detailPanel.pushChildViewController()
    }
    
    func getTaskFromAnnotation(annotation: MKPointAnnotation) -> Task? {
        for taskAnnotation in taskAnnotations {
            if taskAnnotation.annotation.isEqual(annotation) {
                return taskAnnotation.task
            }
        }
        return nil
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                           longitude: location.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredTaskAnnotations.count
        }
        return taskAnnotations.count
    }
    
    // Returns a custom cell populated with sample data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        var task: Task
        if isSearching {
            task = filteredTaskAnnotations[indexPath.row].task
        } else {
            task = taskAnnotations[indexPath.row].task
        }
        if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
            cell.headlineText = "\(task.title ?? "")"
            cell.subheadlineText = "\(task.address?.town ?? ""), \(task.address?.street ?? "") \(task.address?.houseNumber ?? "")"
            cell.footnoteText = "Due on \(task.order?.dueDate?.utc()?.format() ?? "")"
            cell.statusText = taskStatus.text
            cell.detailImage = FUIIconLibrary.map.marker.job.withRenderingMode(.alwaysTemplate)
            cell.detailImageView.tintColor = .white
            cell.detailImageView.isCircular = true
            cell.detailImageView.backgroundColor = taskStatus.color
            cell.statusLabel.textColor = taskStatus.color
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.detailPanel.searchResults.view.endEditing(true)
        if isDetailShown {
            detailPanel.popChildViewController()
        }
        let task: Task
        let annotation: MKPointAnnotation
        if isSearching {
            task = filteredTaskAnnotations[indexPath.row].task
            annotation = filteredTaskAnnotations[indexPath.row].annotation
        } else {
            task = taskAnnotations[indexPath.row].task
            annotation = taskAnnotations[indexPath.row].annotation
        }
        detailPanel.pushChildViewController()
        selectTaskAnnotation(task: task, annotation: annotation)
        isDetailShown = true
    }
}


extension MapViewController: UITableViewDelegate {
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            if let task = getTaskFromAnnotation(annotation: annotation as! MKPointAnnotation) {
                let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as!
                MKMarkerAnnotationView
                if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
                    view.markerTintColor = taskStatus.color
                    view.glyphImage = FUIIconLibrary.map.marker.job
                    view.displayPriority = .required
                }
                return view
            } else {
                return nil // use default blue dot
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation else { return }
        if selectedAnnotation is MKPointAnnotation {
            guard let task = getTaskFromAnnotation(annotation: selectedAnnotation as! MKPointAnnotation) else { return }
            selectTaskAnnotation(task: task, annotation: selectedAnnotation as! MKPointAnnotation)
            detailPanel.content.closeButton.didSelectHandler = { [unowned self] _ in
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
                self.detailPanel.popChildViewController(completion: {
                    self.isDetailShown = false
                })
            }
            if !isDetailShown {
                detailPanel.pushChildViewController {
                    self.isDetailShown = true
                }
            }
            mapView.setCenter(selectedAnnotation.coordinate, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DispatchQueue.main.async {
            if mapView.selectedAnnotations.count == 0 {
                self.detailPanel.popChildViewController(completion: {
                    self.isDetailShown = false
                })
            }
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
        } else {
            isSearching = true
            filteredTaskAnnotations = taskAnnotations.filter({ (taskAnnotation) -> Bool in
                taskAnnotation.task.title?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        detailPanel.searchResults.tableView.reloadData()
    }
}
