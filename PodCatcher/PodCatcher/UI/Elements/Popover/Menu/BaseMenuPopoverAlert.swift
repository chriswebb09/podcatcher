import UIKit

class BaseMenuPopoverAlert: UIView {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = 0.05
        return containerView
    }()
    
    func hidePopView(viewController: UIViewController) {
        containerView.isHidden = true
        viewController.view.sendSubview(toBack: containerView)
    }
}
