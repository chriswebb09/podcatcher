import UIKit

extension LoginViewController: LoginViewDelegate {
    
    func usernameFieldDidAddText(text: String?) {
        guard let text = text else { return }
        print(text)
    }
    
    func submitButtonTapped() {
        print("Submitted")
        delegate?.loginButtonTapped(tapped: true)
    }
}
