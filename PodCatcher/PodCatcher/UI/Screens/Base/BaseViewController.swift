import UIKit

class BaseViewController: UIViewController {
    
    var leftButtonItem: UIBarButtonItem!
    var rightButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}

