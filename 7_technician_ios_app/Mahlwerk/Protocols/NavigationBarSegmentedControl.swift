//
//  NavigationBarSegmentControl.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 11.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

@objc protocol NavigationBarSegmentedControl {
    var segmentedControl: UISegmentedControl { get }
    
    @objc func handleSegmentChanged(sender: UISegmentedControl)
}

extension NavigationBarSegmentedControl where Self: UIViewController {
    
    func addSegmentedControlToNavigationBar() {
        segmentedControl.addTarget(self, action: #selector(handleSegmentChanged(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }
        self.navigationItem.titleView = segmentedControl
    }
}
