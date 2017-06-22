import UIKit

class BasePopoverMenu: UIView {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = 0.2
        return containerView
    }()
    
    func showPopView(viewController: UIViewController) {
        viewController.view.addSubview(containerView)
    }
    
    func hidePopView(viewController: UIViewController){
        viewController.view.sendSubview(toBack: containerView)
    }
}
