import UIKit

protocol ErrorPresenting {
    func presentError(title: String, message: String)
}

extension ErrorPresenting where Self: UIViewController {
    func presentError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}

protocol LoadingPresenting {
    func showLoadingView(loadingPop: LoadingPopover)
    func hideLoadingView(loadingPop: LoadingPopover)
}

extension LoadingPresenting where Self: UIViewController {
    
    func showLoadingView(loadingPop: LoadingPopover) {
        loadingPop.show(controller: self)
    }
    
    func hideLoadingView(loadingPop: LoadingPopover) {
        loadingPop.hidePopView(viewController: self)
    }
}

extension UIViewController {
    
    func setupDefaultUI() {
        navigationController?.navigationBar.barTintColor = .white
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: Colors.brightHighlight]
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey: Any], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for Podcasts...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
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
    
    func dismiss() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
