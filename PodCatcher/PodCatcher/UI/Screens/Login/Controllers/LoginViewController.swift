import UIKit

class LoginViewController: UIViewController {
    
    var loginView = LoginView()
    var loadingPop = LoadingPopover()
    
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
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
