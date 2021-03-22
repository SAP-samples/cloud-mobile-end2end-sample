//
//  UIAlertControllerExtensions.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 29.11.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
