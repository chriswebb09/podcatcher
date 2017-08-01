import UIKit

final class TransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.1
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromNavController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController
        
        if let _ = fromNavController?.topViewController as? SearchViewController {
            if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                toView.alpha = 0
                transitionContext.containerView.addSubview(toView)
                UIView.animate(withDuration: duration, animations: {
                    toView.alpha = 1.0
                }, completion: { _ in
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
