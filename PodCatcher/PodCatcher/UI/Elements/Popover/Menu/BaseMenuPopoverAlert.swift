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
        view.sendSubview(toBack: menu)
    }
}
