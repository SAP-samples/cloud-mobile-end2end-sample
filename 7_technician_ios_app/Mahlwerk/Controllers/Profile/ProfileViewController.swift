//
//  ProfileViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 23.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class ProfileViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        createObjectHeader()
    }
    
    private func configureNavigationBar() {
        if let navbar = self.navigationController?.navigationBar {
            navbar.setValue(true, forKey: "hidesShadow")
        }
    }
    
    private func createObjectHeader() {
        let header = FUIProfileHeader()
        //TODO replace with account name
        header.headlineText = "Sam Miller"
        //TODO replace with account phone number / account email
        header.descriptionText = "Phone: +49 179 1829022\nEmail: sam.miller@service-company.de"
        
        self.tableView.addSubview(header)
    }
    
    @IBAction func changeNotificationSetting(_ sender: UISwitch) {
        //TODO implement
        if sender.isOn {
        } else {
        }
    }
    
    @IBAction func signOutClicked(_ sender: Any) {
        //TODO implement
    }
    
    
}
