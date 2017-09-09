//
//  SpinAnimation.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct SpinAnimation: AnimatableView {
    
    fileprivate let AnimationDuration: Double = 0.08
    fileprivate let AnimationOffset: CGFloat = -40
    
    static func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        let animation = SpinAnimation()
        animation.animate(from: view, with: offset, completion: completion)
    }
    
    func animate(from view: UIView, with offset: CGFloat?, completion: ((Bool) -> Void)?) {
        let offset  = offset ?? AnimationOffset
        let up = CGAffineTransform(translationX: 0, y: offset + 2)
        
        let spinAnimation = UIViewPropertyAnimator(duration: AnimationDuration, dampingRatio: 0.4, animations: {
            view.transform = up
            let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.toValue = CGFloat(2.0 * Double.pi)
            
            rotation.duration = self.AnimationDuration + 0.12
            rotation.repeatCount = 1.0
            rotation.timingFunction = CAMediaTimingFunction(controlPoints: 0.32, 0.80, 0.18, 1.00)
            view.layer.add(rotation, forKey: "rotateStar")
        })
        
        let jumpAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
            view.transform = CGAffineTransform.identity
        })
        
        let growAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
            view.transform = CGAffineTransform(scaleX: -0.25, y: -0.25)
        })
        
        let shrinkAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.1) {
            spinAnimation.startAnimation()
            jumpAnimation.startAnimation()
            growAnimation.startAnimation()
            shrinkAnimation.startAnimation()
        }
    }
}
