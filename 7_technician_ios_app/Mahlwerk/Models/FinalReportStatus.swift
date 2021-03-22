//
//  FinalReportStatus.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 12.09.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation

enum FinalReportStatus: Int64 {
    case notSent = 0
    case sent = 1
    case approved = 2
    
    var text: String {
        switch self {
        case .notSent:
            return "Not Sent"
        case .sent:
            return "Sent"
        case .approved:
            return "Approved"
        }
    }
    
    var id: Int64 {
        return self.rawValue
    }
}
