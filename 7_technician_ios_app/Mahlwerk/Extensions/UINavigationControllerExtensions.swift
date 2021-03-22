//
//  UINavigationControllerExtensions.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 29.11.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import SAPFiori

//set status bar style to light
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let statusBarStyle = FUIStatusBarStyleHelper.statusBarStyle {
            return statusBarStyle
        }
        return .lightContent
    }
}
