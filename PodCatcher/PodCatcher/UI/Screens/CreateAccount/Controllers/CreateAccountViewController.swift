import UIKit

class CreateAccountViewController: UIViewController {
    
    weak var delegate: CreateAccountViewControllerDelegate?
    
    let createAccountView = CreateAccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountView.frame = UIScreen.main.bounds
        createAccountView.tag = 3
        edgesForExtendedLayout = []
        createAccountView.delegate = self
        view = createAccountView
        view.layoutSubviews()
        title = "Create Account"
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - CreateAccountViewDelegate

extension CreateAccountViewController: CreateAccountViewDelegate {
    func submitButtonTapped() {
        delegate?.submitButtonTapped()
    }
}
