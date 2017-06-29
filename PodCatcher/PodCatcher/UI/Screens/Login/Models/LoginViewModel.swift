import UIKit

struct LoginViewModel {
    var username: String = "" {
        didSet {
            print(validContent)
            print(validContentColor)
        }
    }
    var password: String = "" {
        didSet {
            print(validContent)
            print(validContentColor)
        }
    }
    
    var submitEnabled: Bool {
        return self.validContent
    }
    
    var validContent: Bool {
        if username.isValidEmail() && password.characters.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    var validContentColor: UIColor = .mainColor
    var invalidInputColor: UIColor = .semiOffMain
    
    var buttonColor: UIColor {
        if validContent {
            return validContentColor
        } else {
            return invalidInputColor
        }
    }
}
