import UIKit

protocol LoadingViewProtocol {
    var loadingPop: LoadingPopover { get set }
}

extension LoadingViewProtocol {
    func showLoadingView(loadingPop: LoadingPopover, controller: UIViewController) {
        loadingPop.show(controller: controller)
    }
    
    func hideLoadingView(loadingPop: LoadingPopover, controller: UIViewController) {
        loadingPop.hidePopView(viewController: controller)
    }
}

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
