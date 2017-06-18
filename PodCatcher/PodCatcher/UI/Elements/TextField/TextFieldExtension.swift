import UIKit

class TextFieldExtension: UITextField {
    
    // Sets textfield input to + 10 inset on origin x value
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12,
                      y: bounds.origin.y,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12,
                      y: bounds.origin.y,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
   
}

extension TextFieldExtension {
    
    static func configureField(field: UITextField) {
        field.font = UIFont(name: "Avenir-Book", size: 18)!
        field.layer.borderColor = UIColor.mainColor.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 3
    }
    
    static func returnTextField(_ placeholder: String) -> TextFieldExtension {
        let returnTextField = TextFieldExtension()
        returnTextField.placeholder = placeholder
        configureField(field: returnTextField)
        returnTextField.keyboardType = .default
        return returnTextField
    }
    
    static func emailField(_ placeholder: String) -> TextFieldExtension {
        let confirmEmailField = TextFieldExtension()
        confirmEmailField.placeholder = placeholder
        configureField(field: confirmEmailField)
        confirmEmailField.keyboardType = .emailAddress
        return confirmEmailField
    }
    
    static func passwordField() -> TextFieldExtension {
        let passwordField = TextFieldExtension()
        passwordField.placeholder = "Enter password"
        configureField(field: passwordField)
        passwordField.isSecureTextEntry = true
        return passwordField
    }
}
