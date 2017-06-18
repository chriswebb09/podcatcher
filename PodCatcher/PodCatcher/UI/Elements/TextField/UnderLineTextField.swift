import UIKit

class UnderlineTextField: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = CGRect(x: bounds.origin.x + 30,
                               y: bounds.origin.y + 12,
                               width: bounds.width + 12,
                               height: bounds.height)
    
        var textRect = super.leftViewRect(forBounds: newBounds)
        textRect.origin.x += 5
        return textRect
    }

    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 60,
                      y: bounds.origin.y + 12,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 60,
                      y: bounds.origin.y + 12,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    func setup() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}


extension UnderlineTextField {
    
    func setupPasswordField() {
        var image = #imageLiteral(resourceName: "lock")
        leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        leftView = imageView
    }
    
    func setupEmailField() {
        var image = #imageLiteral(resourceName: "mail")
        leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        leftView = imageView
    }

}
