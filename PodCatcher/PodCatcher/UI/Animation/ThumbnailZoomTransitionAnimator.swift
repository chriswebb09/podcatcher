//
//  ThumbnailZoomTransitionAnimator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 9/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class ThumbnailZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 0.5
    var operation: UINavigationControllerOperation = .push
    var thumbnailFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let presenting = operation == .push
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        let podsFeedView = presenting ? fromView : toView
        let podDetailView = presenting ? toView : fromView
        var initialFrame = presenting ? thumbnailFrame : podDetailView.frame
        let finalFrame = presenting ? podDetailView.frame : thumbnailFrame
        let fullFrame = fromView.frame
        let initialFrameAspectRatio = initialFrame.width / initialFrame.height
        let storyDetailAspectRatio = podDetailView.frame.width / podDetailView.frame.height
        
        if initialFrameAspectRatio > storyDetailAspectRatio {
            initialFrame.size = CGSize(width: initialFrame.height * storyDetailAspectRatio, height: initialFrame.height)
        } else {
            initialFrame.size = CGSize(width: initialFrame.width, height: initialFrame.width / storyDetailAspectRatio)
        }
        
        let finalFrameAspectRatio = finalFrame.width / finalFrame.height
        var resizedFinalFrame = finalFrame
        
        if finalFrameAspectRatio > storyDetailAspectRatio {
            resizedFinalFrame.size = CGSize(width: finalFrame.height * storyDetailAspectRatio, height: finalFrame.height)
        } else {
            resizedFinalFrame.size = CGSize(width: finalFrame.width, height: finalFrame.width / storyDetailAspectRatio)
        }
        
        let scaleFactor = resizedFinalFrame.width / initialFrame.width
        let growScaleFactor = presenting ? scaleFactor: 1/scaleFactor
        let shrinkScaleFactor = 1/growScaleFactor
        
        if presenting {
            podDetailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
            podDetailView.center = CGPoint(x: thumbnailFrame.midX, y: thumbnailFrame.midY)
            podDetailView.clipsToBounds = true
        }
        
        podDetailView.alpha = presenting ? 0 : 1
        podsFeedView.alpha = presenting ? 1 : 0
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: podDetailView)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {

            podDetailView.alpha = presenting ? 1 : 0
            podsFeedView.alpha = presenting ? 0 : 1
            
            if presenting {
                
                let scale = CGAffineTransform(scaleX: growScaleFactor, y: growScaleFactor)
                let translate = podsFeedView.transform.translatedBy(x: podsFeedView.frame.midX - self.thumbnailFrame.midX, y: podsFeedView.frame.midY - self.thumbnailFrame.midY)
                podsFeedView.transform = translate.concatenating(scale)
                podDetailView.transform = CGAffineTransform.identity
                
            } else {
                
                podsFeedView.transform = CGAffineTransform.identity
                podsFeedView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                podsFeedView.frame = fullFrame
                
            }
            
            podDetailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
