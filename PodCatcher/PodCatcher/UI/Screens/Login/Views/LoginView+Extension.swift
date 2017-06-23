import UIKit

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        configureSmall()
        updateConstraintsIfNeeded()
        layoutIfNeeded()
        delegate?.loginViewFocus()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        textField.textColor = .black
        textField.leftView?.tintColor = .black
        guard let text = textField.text else { return }
        if textField == usernameField {
            model.username = text
        } else {
            model.password = text
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.leftView?.tintColor = .black
        if textField == usernameField {
            if !text.isValidEmail() {
                textField.textColor = .red
            }
            model.username = text
        } else {
            if text.characters.count < 6 {
                textField.textColor = .red
            }
            model.password = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endEditing(true)
        return true
    }
}
