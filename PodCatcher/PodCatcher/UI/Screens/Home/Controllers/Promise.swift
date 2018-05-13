//
//  Promise.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias ViewClosure = (UIView) -> Void

extension UIView {
    func animate(duration: TimeInterval, animation: @escaping ViewClosure) -> Promise<UIView> {
        return Promise<UIView> { view in
            UIView.animate(withDuration: duration, animations: {
                animation(self)
            }) { finished in
                if finished {
                    view?(self)
                }
            }
        }
    }
}

struct Promise<T> {
    
    typealias completion = (T) -> Void
    
    var task: ((completion?) -> Void)? = nil
    
    init(_ task: @escaping ((completion?) -> Void)) {
        self.task = task
    }
    
    @discardableResult
    func then<U>(_ transform: @escaping (T) -> U) -> Promise<U> {
        return Promise<U>{ completion in
            self.task?() { task in
                let transformed = transform(task)
                completion?(transformed)
            }
        }
    }
    
    func execute() {
        task?(nil)
    }
}
