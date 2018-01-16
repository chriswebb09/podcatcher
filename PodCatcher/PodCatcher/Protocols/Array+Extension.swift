//
//  Array+Extension.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/11/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

extension Sequence where Element: Numeric {
    var sum: Element {
        return self.reduce(0 as Element, +)
    }
}

extension Array where Element == CGSize {
    func width(spacing: CGFloat = 0) -> CGFloat {
        return self.lazy.map { $0.width }.sum + spacing * CGFloat(count-1)
    }
    
    var height: CGFloat {
        return self.map { $0.height }.max() ?? 0
    }
}


extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isEmpty
        case nil:
            return true
        }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case let collection?:
            return collection.isEmpty
        case nil:
            return true
        }
    }
}
