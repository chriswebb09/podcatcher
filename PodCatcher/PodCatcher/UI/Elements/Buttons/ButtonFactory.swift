import UIKit

protocol ButtonMaker {
    var text: String { get set }
    var textColor: UIColor { get set }
    var buttonBorderWidth: CGFloat { get set }
    var buttonBorderColor: CGColor { get set }
    var buttonBackgroundColor: UIColor { get set }
    
    func createButton() -> UIButton
}

class BasicButtonFactory: ButtonMaker {
    var text: String
    var textColor: UIColor
    var buttonBorderWidth: CGFloat
    var buttonBorderColor: CGColor
    var buttonBackgroundColor: UIColor
    
    init(text: String, textColor: UIColor, borderWidth: CGFloat, borderColor: CGColor, backgroundColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.buttonBorderWidth = borderWidth
        self.buttonBorderColor = borderColor
        self.buttonBackgroundColor = backgroundColor
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = buttonBackgroundColor
        button.layer.borderWidth = buttonBorderWidth
        button.setTitle(text, for: .normal)
        return button
    }
}

class LoginButtonFactory: ButtonMaker {
    
    var text: String
    var textColor: UIColor
    var buttonBorderWidth: CGFloat
    var buttonBorderColor: CGColor
    var buttonBackgroundColor: UIColor
    
    init(text: String, textColor: UIColor, buttonBorderWidth: CGFloat, buttonBorderColor: CGColor, buttonBackgroundColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.buttonBorderWidth = buttonBorderWidth
        self.buttonBorderColor = buttonBorderColor
        self.buttonBackgroundColor = buttonBackgroundColor
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 2
        button.backgroundColor = buttonBackgroundColor
        button.layer.borderWidth = buttonBorderWidth
        button.setTitle(text, for: .normal)
        return button
    }
}
