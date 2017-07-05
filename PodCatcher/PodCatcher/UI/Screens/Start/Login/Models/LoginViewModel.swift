import UIKit

struct LoginViewModel {
    var username: String = "" {
        didSet {
            if username.isValidEmail() && password.characters.count >= 6 && !password.isValidEmail() {
                validContent = true
            } else {
                validContent = false
            }
        }
    }
    
    var password: String = "" {
        didSet {
            if username.isValidEmail() && password.characters.count >= 6 && !password.isValidEmail() {
                validContent = true
            } else {
                validContent = false
            }
        }
    }
    
    var submitEnabled: Bool {
        return self.validContent
    }
    
    var validContent: Bool = false

    var validContentColor: UIColor = UIColor(red:0.00, green:0.76, blue:1.00, alpha:1.0)
    var invalidInputColor: UIColor = UIColor(red:0.60, green:0.69, blue:0.71, alpha:1.0)
    
    var buttonColor: UIColor {
        if validContent == true {
            return validContentColor
        }
        return invalidInputColor
    }
}
