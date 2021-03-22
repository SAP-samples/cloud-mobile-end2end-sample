//
//  FinalReportViewController.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 11.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPFioriFlows
import SAPOData
import SAPOfflineOData

class FinalReportViewController: UITableViewController {
    
    private var _order: Order?
    var order: Order {
        get {
            if _order == nil {
                return Order(withDefaults: true)
            }
            return _order!
        }
        set {
            _order = newValue
        }
    }
    
    var odataService: OdataService<OfflineODataProvider>?
    var loadTask: ((_ completionHandler: @escaping (Error?) -> Void) -> Void)?
    
    var header: FUIObjectHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        
        guard let odataService = OnboardingSessionManager.shared.onboardingSession?.odataController.odataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        
        self.odataService = odataService
        self.configureNavigationBar()
        self.createObjectHeader()
    }
    
    private func configureNavigationBar() {
                self.navigationItem.rightBarButtonItem = nil
            }
    
    
    private func createObjectHeader() {
        header = FUIObjectHeader(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 200))
        if let header = header {
            header.headlineLabel.text = "\(order.title ?? "orderTitle")"
            header.subheadlineText = "Machine: \(order.task?.machine?.name ?? "machineName")"
            if(order.task == nil){
                return
            }
            if let finalReportStatus = FinalReportStatus.init(rawValue: order.task!.finalReportStatusID!) {
                header.tags = [FUITag(title: "Status: \(finalReportStatus.text)")]
            }
            self.tableView.tableHeaderView = header
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (order.task?.job.count)!
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "FinalReportCell") as! FinalReportCell
            cell.job = (order.task?.job[indexPath.row])!
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "FinalReportSumCell") as! FinalReportSumCell
            cell.jobs = (order.task?.job)!
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(35 + (self.order.task!.job[indexPath.row].materialPosition.count * 24))
        } else {
            return 35
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 35
        } else {
            return 0.01
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
            view.style = .title
            view.selectionStyle = .none
            view.textLabel?.text = "Jobs"
            
            return view
        }
        return nil
    }
    
}
