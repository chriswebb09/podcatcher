import UIKit

class CreateAccountViewController: UIViewController {
    
    weak var delegate: CreateAccountViewControllerDelegate?
    
    let createAccountView = CreateAccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountView.frame = UIScreen.main.bounds
        createAccountView.tag = 3
        createAccountView.delegate = self
        view = createAccountView
        view.layoutSubviews()
        title = "Create Account"
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - CreateAccountViewDelegate

extension CreateAccountViewController: CreateAccountViewDelegate {
    func submitButtonTapped() {
        delegate?.submitButtonTapped()
    }
}
