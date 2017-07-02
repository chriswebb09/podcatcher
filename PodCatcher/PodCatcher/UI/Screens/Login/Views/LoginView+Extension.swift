import UIKit

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField : UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.characters.count > 0 else { return }
        if textField == emailField {
            model.username = text
            return
        } else {
            model.password = text
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.characters.count > 0 else { return }
        if textField == emailField {
            if !text.isValidEmail() {
                textField.textColor = .red
                return
            } else {
                model.password = text
                textField.textColor = .white
                return
            }
        } else if textField == passwordField {
            if text.characters.count < 6 {
                textField.textColor = .red
                return
            } else {
                model.password = text
                textField.textColor = .white
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField == emailField) ? passwordField : emailField
        nextField.becomeFirstResponder()
        return true
    }
}
