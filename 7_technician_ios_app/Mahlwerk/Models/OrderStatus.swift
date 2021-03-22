//
//  OrderStatus.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 03.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import SAPFiori

enum OrderStatus: Int64 {
    case new = 0
    case open = 1
    case inProgress = 2
    case done = 3
    
    var text: String {
        switch self {
        case .new:
            return "New"
        case .open:
            return "Open"
        case .inProgress:
            return "In Progress"
        case .done:
            return "Done"
        }
    }
    
    var id: Int64 {
        return self.rawValue
    }
    
    var color: UIColor {
        switch self {
        case .new:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.positive)
        case .done:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.primary3)
        case .open:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.chart1)
        case .inProgress:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.critical)
        }
    }
}

enum OrderEventType: Int64 {
    case create = 0
    case open = 1
    case inProgress = 2
    case reportSent = 3
    case reportApproved = 4
    case done = 5
    case message = 6
    
    var id: Int64 {
        return self.rawValue
    }
}

