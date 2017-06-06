import UIKit

class LoginViewController: UIViewController {
    
    var loginView = LoginView()
    
    weak var delegate: LoginViewControllerDelegate?
    
    convenience init(loginView: LoginView) {
        self.init(nibName: nil, bundle: nil)
        self.loginView = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.frame = UIScreen.main.bounds
        loginView.delegate = self
        view = loginView
        view.layoutSubviews()
        title = "Login"
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

extension LoginViewController: LoginViewDelegate {
    
    func usernameFieldDidAddText(text: String?) {
        print(text)
    }
    
    func submitButtonTapped() {
        print("Submitted")
        delegate?.loginButtonTapped(tapped: true)
    }
}
