//
//  MKPointAnnotationExtensions.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 23.05.20.
//  Copyright © 2020 SAP. All rights reserved.
//

import MapKit

extension MKPointAnnotation {
    var taskStatus: TaskStatus? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.type, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.type) as? TaskStatus else {
                return nil
            }
            return value
        }
    }
}
