import UIKit

class LoginBuilder {
    
    class func build(delegate: LoginViewControllerDelegate) -> LoginViewController {
        let loginView = LoginView()
        let loginModel = LoginViewModel()
        loginView.configure(model: loginModel)
        let loginViewController = LoginViewController(loginView: loginView)
        loginViewController.delegate = delegate
        return loginViewController
    }
}
