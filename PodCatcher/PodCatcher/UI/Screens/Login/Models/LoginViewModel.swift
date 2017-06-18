import UIKit

struct LoginViewModel {
    var username: String = ""
    var password: String = ""
    
    var submitEnabled: Bool = false
    
    var validContent: Bool {
        if username.isValidEmail() && password.characters.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    var validContentColor: UIColor = .mainColor
    var invalidInputColor: UIColor = .gray
    
    var buttonColor: UIColor {
        if validContent {
            return validContentColor
        } else {
            return invalidInputColor
        }
    }
}
