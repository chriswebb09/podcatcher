import UIKit

extension UIView {
    
    func constrain(to containerView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        containerView.add(self)
        self.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}


extension UIViewController {

    func embedChild(controller: UIViewController, in container: UIView) {
        self.addChildViewController(controller)
        controller.view.constrain(to: container)
        controller.didMove(toParentViewController: self)
    }

    func removeChild(controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
}

extension UIViewController {
    
    func setupDefaultUI() {
        navigationController?.navigationBar.barTintColor = .white
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: Style.Color.Highlight.brightHighlight]
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
