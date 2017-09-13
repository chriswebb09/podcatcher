//
//  SimpleAnimator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SimpleAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        var containerView = transitionContext.containerView
     
        let background = UIView(frame: UIScreen.main.bounds)
        CALayer.createGradientLayer(with: StartViewConstants.gradientColors, layer: background.layer, bounds: UIScreen.main.bounds)

        let fromFrame = fromViewController?.view.frame
        UIView.animate(withDuration: 0.25, animations: {
            let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            transform.concatenating(CGAffineTransform(rotationAngle: CGFloat(Double.pi)))
            toViewController.view.frame = UIScreen.main.bounds
            fromViewController?.view.transform = transform

        }, completion: { finished in
             containerView.addSubview(background)
            
            let smallTransform = CGAffineTransform(scaleX: 0, y: 0)
            toViewController.view.transform = smallTransform
            let transform = CGAffineTransform(scaleX: 1, y: 1)
            
            transform.concatenating(CGAffineTransform(rotationAngle: CGFloat(Double.pi)))
 
            fromViewController?.view.alpha = 0
            containerView.addSubview(toViewController.view)
            let duration = self.transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: duration, animations: {
                toViewController.view.transform = transform
                toViewController.view.alpha = 1.0
                fromViewController?.view.transform = transform
            }, completion: { finished in
                fromViewController?.view.alpha = 1
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
                background.removeFromSuperview()
            })
        })
    }
}

