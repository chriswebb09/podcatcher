import UIKit

class LoginViewController: BaseViewController {
    
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
        let model = LoginViewModel()
        loginView.model = model
        view = loginView
        view.layoutSubviews()
        title = "Sign In"
        view.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleRightMargin, .flexibleWidth, .flexibleLeftMargin, .flexibleTopMargin]
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
