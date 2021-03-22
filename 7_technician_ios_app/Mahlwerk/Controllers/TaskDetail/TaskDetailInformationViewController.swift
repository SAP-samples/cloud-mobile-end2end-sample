//
//  TaskDetailInformationViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 24.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import MapKit

class TaskDetailInformationViewController: UITableViewController, UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FUITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        self.tableView.register(FUINoteFormCell.self, forCellReuseIdentifier: FUINoteFormCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 35
        } else {
            return 0.1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  tableView.dequeueReusableHeaderFooterView(withIdentifier:
            FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.selectionStyle = .none
        if section == 0 {
            view.titleLabel.text = "Location"
            return view
        } else if section == 1 {
            view.titleLabel.text = "Notes"
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            return cell
        } else if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: FUINoteFormCell.reuseIdentifier)
                as! FUINoteFormCell
            cell.valueTextView.text = "This is a note."
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomerCell")!
                return cell
            } else if indexPath.row == 1 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderCell")!
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReportCell")!
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let mapVC = tabBarController?.viewControllers![1] as! MapViewController
            tabBarController?.selectedViewController = mapVC
            mapVC.displaySingleLocation(address: "Martin-Schongauer-Weg 28 76149 Karlsruhe",
                                        title: "CC Consulting: Repair")
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // TODO add segue to customer
            } else if indexPath.row == 1 {
                // TODO add segue to order
            } else {
                // TODO add segue to final report
            }
        }
    }
    
    //resizing notes textview
    func updateTableViewContentOffsetForTextView() {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}
