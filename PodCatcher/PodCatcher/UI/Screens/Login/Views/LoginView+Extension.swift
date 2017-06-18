import UIKit

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField == usernameField {
            model.username = text
        } else {
            model.password = text
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField == usernameField {
            model.username = text
        } else {
            model.password = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endEditing(true)
        return true
    }
}
