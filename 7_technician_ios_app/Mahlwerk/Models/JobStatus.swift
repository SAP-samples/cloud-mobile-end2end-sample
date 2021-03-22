//
//  JobStatus.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 27.08.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

enum JobStatus: Int64 {
    case open = 0
    case done = 1
    
    var text: String {
        switch self {
        case .open:
            return "Open"
        case .done:
            return "Done"
        }
    }
    
    var color: UIColor {
        switch self {
        case .done:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.primary3)
        case .open:
            return UIColor.preferredFioriColor(forStyle: FUIColorStyle.chart1)
        }
    }
    
    var id: Int64 {
        return self.rawValue
    }
}
