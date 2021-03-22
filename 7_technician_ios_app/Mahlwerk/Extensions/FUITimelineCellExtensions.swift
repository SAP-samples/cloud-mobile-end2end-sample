//
//  FUITimelineCellExtensions.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 29.11.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import SAPFiori

extension FUITimelineCell {
    var type: FUITimelineCellType {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.type, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.type) as? FUITimelineCellType else {
                return .message
            }
            return value
        }
    }
}

struct AssociatedKeys {
    static var type: UInt8 = 0
}
