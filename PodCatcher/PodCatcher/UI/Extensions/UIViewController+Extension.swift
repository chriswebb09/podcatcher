import UIKit

extension UIViewController {
    
    func setupDefaultUI() {
        navigationController?.navigationBar.barTintColor = .white
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: Colors.brightHighlight]
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes as? [String : Any], for: .normal)
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
    
    @objc func dismissKeyboard() {
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
        DispatchQueue.main.async {
            let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
                actionSheetController.dismiss(animated: false, completion: nil)
            }
            actionSheetController.addAction(okayAction)
            self.present(actionSheetController, animated: false)
        }
    }
}

public extension UIViewController {
    
    func presentAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let closeButton = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(closeButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
