import UIKit

enum ButtonType {
    
    case login(title:String), system(title:String, color: UIColor), tag(title:String, color:UIColor, tag: Int, index: IndexPath)
    
    fileprivate func setupLoginButton(with title:String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = Constants.Color.mainColor.setColor
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        return button
    }
    
    fileprivate func configureButton(button:UIButton) {
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
    }
    
    fileprivate func setupSystemButton(with title:String, color: UIColor?) -> UIButton {
        let button = UIButton()
        let buttonColor = color ?? .black
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: buttonColor,
                                                                                  NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        return button as UIButton
    }
  
    public var newButton: UIButton {
        switch self {
        case let .login(title):
            return setupLoginButton(with: title)
        case let .system(title, color):
            return setupSystemButton(with: title, color: color)
        default:
            return UIButton()
        }
    }
}
