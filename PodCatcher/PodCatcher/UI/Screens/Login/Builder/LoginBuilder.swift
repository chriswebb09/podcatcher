import UIKit

class LoginBuilder {
    
    class func build(delegate: LoginViewControllerDelegate) -> LoginViewController {
//        let loginView = LoginView()
//        let loginModel = LoginViewModel()
//        loginView.configure(model: loginModel)
        let loginViewController = LoginViewController()
        loginViewController.delegate = delegate
        return loginViewController
    }
}
