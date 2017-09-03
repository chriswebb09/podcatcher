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
        return 0.15
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        let containerView = transitionContext.containerView
        let fromFrame = fromViewController?.view.frame
        UIView.animate(withDuration: 0.14, animations: {
            let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            transform.concatenating(CGAffineTransform(rotationAngle: CGFloat(Double.pi)))
            toViewController.view.frame = fromFrame!
            fromViewController?.view.transform = transform
        }, completion: { finished in
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
            })
        })
    }
}

