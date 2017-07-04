import UIKit

extension UpdateAccountView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameField {
            guard let text = textField.text else { return }
            delegate?.usernameUpdated(username: text)
        } else if textField == emailField {
            guard let text = textField.text, text.isValidEmail() else { return }
            delegate?.emailUpdated(email: text)
        }
    }
}
