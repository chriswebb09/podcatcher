import UIKit

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
