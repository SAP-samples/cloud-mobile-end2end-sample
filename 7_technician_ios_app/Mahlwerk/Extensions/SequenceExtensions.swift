//
//  SequenceExtensions.swift
//  Mahlwerk
//
//  Created by Robin Kuck on 29.11.19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation

extension Sequence {
    func group<Key>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] where Key: Hashable {
        return Dictionary(grouping: self, by: {
            $0[keyPath: keyPath]
        })
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}
