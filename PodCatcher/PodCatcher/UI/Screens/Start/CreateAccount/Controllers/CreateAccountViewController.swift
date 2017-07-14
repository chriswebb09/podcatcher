import UIKit

class CreateAccountViewController: UIViewController {
    
    weak var delegate: CreateAccountViewControllerDelegate?
    
    let createAccountView = CreateAccountView()
    let downloadIndicator = DownloaderIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountView.frame = UIScreen.main.bounds
        createAccountView.tag = 3
        createAccountView.delegate = self
        view = createAccountView
        view.layoutSubviews()
        title = "Create Account"
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
}
