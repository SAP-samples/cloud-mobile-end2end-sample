//
//  MapDetailPanelContentController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 01.08.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import MapKit

class MapDetailPanelContentControllerObject: NSObject {
    
    enum Row: Int, CaseIterable {
        case route, task, statusChange
    }
    
    var task: Task
    var coordinate: CLLocationCoordinate2D
    var viewController: MapViewController
    
    init(task: Task, coordinate: CLLocationCoordinate2D, viewController: MapViewController) {
        self.task = task
        self.coordinate = coordinate
        self.viewController = viewController
    }
    
    var headlineText: String? {
        return "\(task.title ?? "")"
    }
    
    var subheadlineText: String? {
       var dueDate = ""
        if task.order != nil{
            dueDate = (task.order?.dueDate?.utc()?.format())!
        }
       return "Due on \( dueDate)"
    }
    
}

extension MapDetailPanelContentControllerObject: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row(rawValue: indexPath.row) {
        case .route:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIMapDetailPanel.ButtonTableViewCell.reuseIdentifier) as! FUIMapDetailPanel.ButtonTableViewCell
            cell.button.titleLabel?.text = "Route"
            cell.descriptionLabel.text = "\(task.address?.town ?? ""), \(task.address?.street ?? "") \(task.address?.houseNumber ?? "")"
            cell.button.didSelectHandler = { [unowned self] _ in
                let coordinateMake = CLLocationCoordinate2DMake(self.coordinate.latitude, self.coordinate.longitude)
                let region = MKCoordinateRegion(center: coordinateMake, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
                let destinationPlacemark = MKPlacemark(coordinate: coordinateMake, addressDictionary: nil)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                destinationMapItem.name = self.task.title
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
                MKMapItem.openMaps(with: [destinationMapItem], launchOptions: options)
            }
            return cell
        case .task:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIMapDetailPanel.ActionTableViewCell.reuseIdentifier) as!
                FUIMapDetailPanel.ActionTableViewCell
            cell.actionTitleLabel.text = "Show Task"
            cell.actionImageView.image = FUIIconLibrary.docType.generic.withRenderingMode(.alwaysTemplate)
            return cell
        case .statusChange:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIMapDetailPanel.ActionTableViewCell.reuseIdentifier) as! FUIMapDetailPanel.ActionTableViewCell
            if let taskStatus = TaskStatus.init(rawValue: self.task.taskStatusID!) {
                cell.actionImageView.image = FUIIconLibrary.app.changeStatus.withRenderingMode(.alwaysTemplate)
                switch taskStatus {
                case .open:
                    cell.actionTitleLabel.text = "Schedule"
                case .scheduled:
                    cell.actionTitleLabel.text = "Set Active"
                case .active:
                    cell.actionTitleLabel.text = "Set Done"
                default:
                    break
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row.init(rawValue: indexPath.row) {
        case .task:
            self.viewController.mapView.deselectAnnotation(self.viewController.mapView.selectedAnnotations[0],
                                                           animated: true)
            self.viewController.detailPanel.popChildViewController(completion: {
                self.viewController.presentedViewController?.dismiss(animated: true, completion: {
                    let taskDetailStoryboard = UIStoryboard(name: "TaskDetail", bundle: nil)
                    let taskDetailViewController = taskDetailStoryboard.instantiateInitialViewController() as! TaskDetailViewController
                    taskDetailViewController.task = self.task
                    
                    let mapNavigationViewController = self.viewController.navigationController!
                    mapNavigationViewController.pushViewController(taskDetailViewController, animated: true)
                })
            })
        case .statusChange:
            if let taskStatus = TaskStatus.init(rawValue: self.task.taskStatusID!) {
                // check if there is an active task
                if taskStatus == TaskStatus.scheduled {
                    for task in self.viewController.tasks {
                        let taskStatus = TaskStatus.init(rawValue: task.taskStatusID!)
                        if taskStatus == .active {
                            let alert = UIAlertController(title: "Error", message: "Please finish your active Task until you start a new one!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.viewController.detailPanel.presentContainer()
                            }))
                            self.viewController.detailPanel.popChildViewController(completion: {
                                self.viewController.presentedViewController?.dismiss(animated: true, completion: {
                                    self.viewController.present(alert, animated: true, completion: nil)
                                    return
                                })
                            })
                        }
                    }
                }
                if let targetStatus = TaskStatus.init(rawValue: taskStatus.id+1) {
                    let alert = UIAlertController(title: "Change Status", message: "Change Status of Task to \(targetStatus.text)?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        switch taskStatus {
                        case TaskStatus.open:
                            self.task.taskStatusID = TaskStatus.scheduled.id
                        case TaskStatus.scheduled:
                            self.task.taskStatusID = TaskStatus.active.id
                        case TaskStatus.active:
                            self.task.taskStatusID = TaskStatus.done.id
                        default:
                            return
                        }
                        //TODO edit open tasks tasks in online store
                        self.viewController.odataService?.updateEntity(self.task, completionHandler: { (error) in
                            if error != nil {
                            } else {
                                self.viewController.addAnnotations()
                                self.viewController.odataService?.provider.upload(completionHandler: { (error) in
                                    
                                })
                            }
                        })
                        self.viewController.detailPanel.presentContainer()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.viewController.detailPanel.presentContainer()
                    }))
                    self.viewController.mapView.deselectAnnotation(self.viewController.mapView.selectedAnnotations[0],
                                                                   animated: true)
                    self.viewController.detailPanel.popChildViewController(completion: {
                        self.viewController.presentedViewController?.dismiss(animated: true, completion: {
                            self.viewController.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }
        default:
            break
        }
    }
}
