import UIKit

class BaseViewController: UIViewController {
    
    var leftButtonItem: UIBarButtonItem!
    var rightButtonItem: UIBarButtonItem!
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyView = EmptyView(frame: UIScreen.main.bounds)
        hideKeyboardWhenTappedAround()
        edgesForExtendedLayout = []
    }
    
    func showMenu() {
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(hideMenu))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
    
    func hideMenu() {
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(showMenu))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
}


