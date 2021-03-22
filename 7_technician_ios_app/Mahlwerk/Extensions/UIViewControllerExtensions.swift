//
//  UIViewControllerExtensions.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 29.11.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

extension UIViewController {
    func displayOfflineMessageBar() {
        displayMessageBar(text: "There is no Internet Connection.")
    }
    
    func displayMessageBar(text: String) {
        guard let navBar = self.navigationController?.navigationBar as? FUINavigationBar else {
            return
        }
        DispatchQueue.main.async {
            navBar.bannerView?.show(message: text, withDuration: 1.5, animated: true)
        }
    }
}
