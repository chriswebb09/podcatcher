//
//  BigAnimation.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class BigAnimation: AnimatableView {
    
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        
    }
    
    private func setupSlowAnimation(animation: CABasicAnimation) {
        animation.duration = 0.3
        animation.fromValue = 1
        animation.toValue = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 2
    }
    
    private func animateYSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        setupSlowAnimation(animation: animation)
        return animation
    }
    
    private func animateXSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        setupSlowAnimation(animation: animation)
        return animation
    }
}
