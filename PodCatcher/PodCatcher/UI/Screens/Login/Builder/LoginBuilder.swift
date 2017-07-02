import UIKit

class LoginBuilder {
    
    class func build(delegate: LoginViewControllerDelegate) -> LoginViewController {
        let loginViewController = LoginViewController()
        loginViewController.delegate = delegate
        return loginViewController
    }
}
