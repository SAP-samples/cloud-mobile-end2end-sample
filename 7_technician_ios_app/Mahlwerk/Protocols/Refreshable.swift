//
//  Refreshable.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 11.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

@objc protocol Refreshable {
    var myRefreshControl: UIRefreshControl { get }
    
    @objc func handleRefresh(_ sender: Any)
}


extension Refreshable where Self: UITableViewController
{

    func addRefreshControl(tintColor: UIColor? = nil)
    {
        if let tintColor = tintColor {
            myRefreshControl.tintColor = tintColor
        }
        myRefreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.tableView.addSubview(myRefreshControl)
    }
    
    func endRefreshing() {
        myRefreshControl.endRefreshing()
    }
}
