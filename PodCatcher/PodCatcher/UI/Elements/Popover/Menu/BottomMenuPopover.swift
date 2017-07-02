import UIKit

class BottomMenu {
    
    var menu: MenuView = {
        let menuView = MenuView()
        menuView.isUserInteractionEnabled = true
        return menuView
    }()
    
    func setMenu(_ size: CGSize) {
        menu.frame.size = size
    }
    
    func setMenu(_ origin: CGPoint) {
        menu.frame.origin = origin
    }
    
    func setMenu(color: UIColor, borderColor: UIColor, textColor: UIColor) {
        menu.setMenuColor(backgroundColor: color, borderColor: borderColor, labelTextColor: textColor)
    }
    
    func setupMenu() {
        menu.isUserInteractionEnabled = true
        menu.configureView()
    }
    
    func showOn(_ view: UIView) {
        view.addSubview(menu)
        view.bringSubview(toFront: menu)
    }
    
    func hideFrom(_ view: UIView) {
        print("hideFrom(_ view: UIView)")
        view.sendSubview(toBack: menu)
    }
}



final class BottomMenuPopover: BasePopoverMenu {
    
    var popView: MenuView = {
        let popView = MenuView()
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        
        UIView.animate(withDuration: 0.5) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.popView.alpha = 1
                strongSelf.popView.frame = CGRect(x: viewController.view.bounds.width * 0.001,
                                                  y: viewController.view.bounds.height * 0.6,
                                                  width: viewController.view.bounds.width,
                                                  height: viewController.view.bounds.height * 0.5)
               // strongSelf.layoutIfNeeded()
            }
        }
        let tap = UIGestureRecognizer(target: self, action: #selector(hidePopView(viewController:)))
        containerView.addGestureRecognizer(tap)
    }
    
    public override func hidePopView(viewController: UIViewController) {
        super.hidePopView(viewController: viewController)
         //popView.removeFromSuperview()
    }
    
    func dismissMenu(controller: UIViewController) {
        removeFromSuperview()
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
    
    func hideMenu(controller: UIViewController) {
//        hidePopView(viewController: controller)
        popView.removeFromSuperview()
    }
    
    func setContainerOpacity() {
        containerView.alpha = 0
    }
    
    func setColor(color: UIColor, borderColor: UIColor, textColor: UIColor) {
        popView.setMenuColor(backgroundColor: color, borderColor: borderColor, labelTextColor: textColor)
    }
    
    func setupPop() {
        popView.isUserInteractionEnabled = true
        popView.configureView()
    }
}



