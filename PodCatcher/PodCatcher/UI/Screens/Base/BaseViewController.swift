import UIKit

class BaseViewController: UIViewController {
    
    var sideMenuPop: SideMenuPopover!
    var leftButtonItem: UIBarButtonItem!
    var rightButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        edgesForExtendedLayout = []
    }
    
    func showMenu() {
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(hideMenu))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        
        UIView.animate(withDuration: 0.15) {
            self.sideMenuPop.showPopView(viewController: self)
            self.sideMenuPop.popView.isHidden = false
        }
    }
    
    func hideMenu() {
        sideMenuPop.hideMenu(controller: self)
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(showMenu))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
}


