//
//  LayerAnimationDelegate.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

import UIKit

typealias LayerAnimationBeginClosure = (CAAnimation) -> Void
typealias LayerAnimationCompletionClosure = (CAAnimation, Bool) -> Void

class LayerAnimationDelegate: NSObject {
    var beginClosure: LayerAnimationBeginClosure?
    var completionClosure: LayerAnimationCompletionClosure?
}

extension LayerAnimationDelegate: CAAnimationDelegate {
    
    func animationDidStart(_ animation: CAAnimation) {
        guard let beginClosure = beginClosure else { return }
        beginClosure(animation)
    }
    
    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        guard let completionClosure = completionClosure else { return }
        completionClosure(animation, finished)
    }
}
