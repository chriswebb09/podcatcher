import UIKit

final class SideMenuPopover: BasePopoverMenu {
    
    var popView: SideMenuView = {
        let popView = SideMenuView()
        popView.isUserInteractionEnabled = true
        popView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: self)
        popView.isHidden = false
        popView.translatesAutoresizingMaskIntoConstraints = false
        popView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: 0.5).isActive = true
        popView.heightAnchor.constraint(equalTo: viewController.view.heightAnchor).isActive = true
        popView.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        popView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
    }
    
    public override func hidePopView(viewController: UIViewController) {
        super.hidePopView(viewController: viewController)
        popView.isHidden = true
    }
    
    func dismissMenu(controller: UIViewController) {
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
    
    func hideMenu(controller: UIViewController) {
        hidePopView(viewController: controller)
    }
    
    func setupPop() {
        popView.isUserInteractionEnabled = true
        popView.configureView()
        popView.layer.borderWidth = 1.5
    }
}



