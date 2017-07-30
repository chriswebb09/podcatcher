import UIKit

extension UIViewController {
    
    func setupDefaultUI() {
        navigationController?.navigationBar.barTintColor = .white
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: Colors.brightHighlight]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for Podcasts...", attributes: [NSForegroundColorAttributeName: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
    
    func changeView(forView: UIView, withView: UIView) {
        view.sendSubview(toBack: withView)
        view.bringSubview(toFront: forView)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    
    func showLoadingView(loadingPop: LoadingPopover) {
        loadingPop.show(controller: self)
    }
    
    func hideLoadingView(loadingPop: LoadingPopover) {
        loadingPop.hidePopView(viewController: self)
    }
    
    func showError(errorString: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
            actionSheetController.dismiss(animated: false, completion: nil)
        }
        actionSheetController.addAction(okayAction)
        present(actionSheetController, animated: false)
    }
}
