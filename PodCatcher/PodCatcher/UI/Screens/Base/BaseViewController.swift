import UIKit

class BaseViewController: UIViewController {
    
    var leftButtonItem: UIBarButtonItem!
    var rightButtonItem: UIBarButtonItem!
    var emptyView: InformationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        edgesForExtendedLayout = []
    }
}
