import UIKit

protocol PopAlert {
    var containerView: UIView  { get }
    func showPopView(viewController: UIViewController)
    func hidePopView(viewController: UIViewController)
    func configureContainer()
}

class BasePopoverAlert: UIView, PopAlert {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = BasePopoverAlertConstants.containerOpacity
        return containerView
    }()
    
    func showPopView(viewController: UIViewController) {
        containerView.isHidden = false
        containerView.frame = UIScreen.main.bounds
        containerView.center = CGPoint(x: BasePopoverAlertConstants.popViewX, y: BasePopoverAlertConstants.popViewY)
        viewController.view.addSubview(containerView)
    }
    
    func hidePopView(viewController: UIViewController){
        viewController.view.sendSubview(toBack: containerView)
        containerView.isHidden = true
    }
    
    func configureContainer() {
        containerView.layer.opacity = 0
    }
}
