import UIKit

class LoginViewController: BaseViewController {
    
    var loginView = LoginView()
    weak var delegate: LoginViewControllerDelegate?
    let downloadIndicator = DownloaderIndicatorView()
    
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
        downloadIndicator.activityIndicatorSetup()
        view = loginView
        view.layoutSubviews()
        title = "Sign In"
        navigationController?.navigationBar.alpha = 0
        view.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleRightMargin, .flexibleWidth, .flexibleLeftMargin, .flexibleTopMargin]
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.backgroundColor = .white
    }
}
