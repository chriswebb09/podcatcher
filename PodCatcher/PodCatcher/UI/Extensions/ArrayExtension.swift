//
//  Array+Extension.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for (key, value) in self.enumerated() {
            if result.contains(value) {
                self.remove(at: key)
            } else {
                result.append(value)
            }
        }
    }
}
