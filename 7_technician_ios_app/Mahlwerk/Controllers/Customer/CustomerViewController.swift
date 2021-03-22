//
//  CustomerViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 29.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPOData
import SAPFioriFlows

class CustomerViewController: UITableViewController, FUIActivityControlDelegate, SAPFioriLoadingIndicator {

    var orders = [Order]()
    
    private var _customer: Customer?
    var customer: Customer {
        get {
            if _customer == nil {
                return Customer(withDefaults: true)
            }
            return _customer!
        }
        set {
            _customer = newValue
        }
    }
    var loadCustomer: ((_ completionHandler: @escaping (Error?) -> Void) -> Void)?
    var loadingIndicator: FUILoadingIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        
        createObjectHeader()
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        func fetchCustomer(_ completionHandler: @escaping (Error?) -> Void) {
            do {
                odataService.loadProperty(Customer.address, into: customer, completionHandler: completionHandler)
            }
        }
        loadCustomer = fetchCustomer
        
        updateTable()
    }
    
    @objc func refresh() {
        DispatchQueue.global().async {
            self.loadData {
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func updateTable() {
        self.showFioriLoadingIndicator()
        DispatchQueue.global().async {
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        }
    }
    
    private func loadData(completionHandler: @escaping () -> Void) {
        self.requestTask { error in
            defer {
                completionHandler()
            }
            if let error = error {
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func requestTask(completionHandler: @escaping (Error?) -> Void) {
        self.loadCustomer!() { error in
            if let error = error {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    
    func createObjectHeader() {
        let header = FUIProfileHeader()
        self.tableView.addSubview(header)
        header.headlineText = "\(customer.name ?? "customerName")"
        header.descriptionText = "Email: \(customer.email ?? "customerEmail")\nPhone: \(customer.phone ?? "customerPhone")"
        
        let activityControl = FUIActivityControl()
        activityControl.maxVisibleItems = 3
        activityControl.itemSize = CGSize(width: 24, height: 24)
        activityControl.spacing = CGFloat(36.0)
        
        let emailActivity = FUIActivityItem.email
        let phoneActivity = FUIActivityItem.phone
        activityControl.addActivities([emailActivity, phoneActivity])
        header.detailContentView = activityControl
    }
    
    func activityControl(_ activityControl: FUIActivityControl, didSelectActivity activityItem: FUIActivityItem) {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return orders.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.style = .title
        view.selectionStyle = .none
        
        switch section {
        case 0:
            view.titleLabel.text = "Address"
        case 1:
            view.titleLabel.text = "Default"
        default:
            return nil
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        } else {
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.address = customer.address
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let mapStoryboard = UIStoryboard(name: "Map", bundle: nil)
            let mapNavigationViewController = mapStoryboard.instantiateInitialViewController() as! UINavigationController
            let mapViewController = mapNavigationViewController.visibleViewController as! MapViewController
            mapViewController.displaySingleLocation(address: self.customer.address!, title: self.customer.companyName!)
            mapViewController.showDetailPanel = false
            self.present(mapNavigationViewController, animated: true)
        }
    }
    
}
