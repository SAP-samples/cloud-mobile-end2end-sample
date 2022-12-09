//
//  ProfileViewController.swift
//  Technician-Controls
//
//  Created by Kuck, Robin on 23.07.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPFoundation
import SAPCommon
import SAPFioriFlows

class ProfileViewController: FUIFormTableViewController {
    var userName: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRegistrationInfo()
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .header)
        
        configureNavigationBar()
        
    }
    
    func loadRegistrationInfo() {
        let settingsParameters = OnboardingSessionManager.shared.onboardingSession?.settingsParameters!
        let urlSession = OnboardingSessionManager.shared.onboardingSession?.sapURLSession
        let userRoles = SAPcpmsUserRoles(sapURLSession: urlSession!, settingsParameters: settingsParameters!)
      var data = [String: Any]()
      data["DeviceId"] = SAPcpmsSettingsParameters.defaultDeviceID
        userRoles.load { [self] userInfo, error in
            userName = userInfo?.userName ?? ""
            email = userInfo?.emails?.first?.first?.value as! String
            DispatchQueue.main.async { [self] in
                createObjectHeader()
            }
        }
  
    }
    
    private func configureNavigationBar() {
        if let navbar = self.navigationController?.navigationBar {
            navbar.setValue(true, forKey: "hidesShadow")
        }
    }
    
    private func createObjectHeader() {
        let header = FUIProfileHeader()
        //TODO replace with account name
        header.headlineText = userName
        //TODO replace with account phone number / account email
        header.descriptionText = "Email: \(email)"
        
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
