import UIKit

class UnderlineTextField: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = CGRect(x: bounds.origin.x + 30,
                               y: bounds.origin.y + 8,
                               width: bounds.width + 12,
                               height: bounds.height)
        
        var textRect = super.leftViewRect(forBounds: newBounds)
        textRect.origin.x += 5
        return textRect
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 50,
                      y: bounds.origin.y + 12,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 50,
                      y: bounds.origin.y + 12,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    func setup() {
        let border = CALayer()
        let width = CGFloat(1.2)
        border.borderColor = UIColor.gray.cgColor
        
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}


extension UnderlineTextField {
    
    func setupPasswordField() {
        var image = #imageLiteral(resourceName: "lock").withRenderingMode(.alwaysTemplate)
        leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 28))
        imageView.image = image
        imageView.tintColor = .gray
        leftView = imageView
        let attributedString = NSMutableAttributedString(string: "Password")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        let fontAttribute = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 16)]
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        attributedPlaceholder = attributedString
        textColor = .lightGray
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        accessibilityLabel = "password-field"
    }
    
    func setupEmailField() {
        var image = #imageLiteral(resourceName: "mail-cropped").withRenderingMode(.alwaysTemplate)
        leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.tintColor = .gray
        imageView.image = image
        leftView = imageView
        let attributedString = NSMutableAttributedString(string: "Email Address")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        let fontAttribute = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 16)]
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        attributedPlaceholder = attributedString
        if let text = text {
            
            let attributedString = NSMutableAttributedString(string: text.lowercased())
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    
    
    func setupUserField() {
        var image = #imageLiteral(resourceName: "user").withRenderingMode(.alwaysTemplate)
        leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 28))
        imageView.tintColor = .lightGray
        imageView.image = image
        leftView = imageView
        let attributedString = NSMutableAttributedString(string: "Username")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        let fontAttribute = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 16)]
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        attributedPlaceholder = attributedString
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
