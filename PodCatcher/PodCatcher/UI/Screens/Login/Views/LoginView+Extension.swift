import UIKit

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.characters.count > 0 else { return }
        textField.textColor = .black
        textField.leftView?.tintColor = .black
        if textField == emailField {
            model.username = text
        } else {
            model.password = text
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.characters.count > 0 else { return }
        textField.leftView?.tintColor = .black
        if textField == emailField {
            if !text.isValidEmail() {
                textField.textColor = .red
                return
            }
            model.password = text
            textField.textColor = .black
        } else if textField == passwordField {
            if text.characters.count < 6 {
                textField.textColor = .red
                return
            }
            model.password = text
            textField.textColor = .black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField == emailField) ? passwordField : emailField
        nextField.becomeFirstResponder()
        return true
    }
}
