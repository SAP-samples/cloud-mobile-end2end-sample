//
//  MapButtonCell.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 23.05.20.
//  Copyright © 2020 SAP. All rights reserved.
//

import UIKit
import MapKit
import SAPFiori

class MapButtonCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: FUIMKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.delegate = self
        mapView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAnnotations(tasks: [Task]) {
        mapView.removeAnnotations(mapView.annotations)
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
                            if let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!) {
                                annotation.taskStatus = taskStatus
                            }
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as!
            MKMarkerAnnotationView
            view.markerTintColor = pointAnnotation.taskStatus?.color
            view.glyphImage = FUIIconLibrary.map.marker.job
            view.displayPriority = .required
            view.isEnabled = false
            return view
        }
        return nil
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}
