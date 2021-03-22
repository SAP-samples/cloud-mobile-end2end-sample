//
//  DateExtension.swift
//  Mahlwerk
//
//  Created by Kuck, Robin on 06.08.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori

extension Date {
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}



