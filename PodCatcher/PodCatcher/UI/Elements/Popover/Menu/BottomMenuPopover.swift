import UIKit

final class BottomMenuPopover: BasePopoverMenu {
    
    var popView: MenuView = {
        let popView = MenuView()
        popView.backgroundColor = UIColor(red:0.09, green:0.14, blue:0.31, alpha:1.0)
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.popView.frame = CGRect(x: viewController.view.bounds.width,
                                              y: viewController.view.bounds.height * 6.5,
                                              width: viewController.view.bounds.width * 0,
                                              height: viewController.view.bounds.height * 0)
            strongSelf.popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.45)
            strongSelf.layoutIfNeeded()
            strongSelf.popView.alpha = 0
        }
        
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        
        UIView.animate(withDuration: 5) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.popView.alpha = 1
                strongSelf.popView.frame = CGRect(x: viewController.view.bounds.width * 0.001,
                                                  y: viewController.view.bounds.height * 0.58,
                                                  width: viewController.view.bounds.width,
                                                  height: viewController.view.bounds.height * 0.42)
                strongSelf.layoutIfNeeded()
            }
        }
        
        let tap = UIGestureRecognizer(target: self, action: #selector(hidePopView(viewController:)))
        containerView.addGestureRecognizer(tap)
    }
    
    
    public override func hidePopView(viewController: UIViewController) {
        super.hidePopView(viewController: viewController)
    }
    
    func dismissMenu(controller: UIViewController) {
        removeFromSuperview()
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
    
    func setupPop() {
        popView.isUserInteractionEnabled = true
        popView.configureView()
        popView.layer.borderWidth = 1.5
    }
}
