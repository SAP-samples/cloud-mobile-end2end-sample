//
//  TaskStatus.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 06.08.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

enum TaskStatus: Int64 {
    case active = 2
    case done = 3
    case open = 0
    case scheduled = 1
    
    var text: String {
        switch self {
        case .active:
            return "Active"
        case .done:
            return "Done"
        case .open:
            return "Open"
        case .scheduled:
            return "Scheduled"
        }
    }
    
    var color: UIColor {
        switch self {
        case .active:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.positive)
        case .done:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.primary3)
        case .open:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.chart1)
        case .scheduled:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.critical)
        }
    }
    
    var id: Int64 {
        return self.rawValue
    }
}
