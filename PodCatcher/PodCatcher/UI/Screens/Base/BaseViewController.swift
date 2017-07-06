import UIKit

class BaseViewController: UIViewController {
    
    var leftButtonItem: UIBarButtonItem!
    var rightButtonItem: UIBarButtonItem!
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView = EmptyView(frame: UIScreen.main.bounds)
        hideKeyboardWhenTappedAround()
        edgesForExtendedLayout = []
    }
}


