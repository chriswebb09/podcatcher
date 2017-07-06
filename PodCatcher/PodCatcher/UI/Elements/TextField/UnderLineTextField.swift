import UIKit

final class UnderlineTextField: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = CGRect(x: bounds.origin.x + UnderlineTextFieldConstants.newBoundsOriginXOffset,
                               y: bounds.origin.y + UnderlineTextFieldConstants.newBoundsOriginYOffset,
                               width: bounds.width + UnderlineTextFieldConstants.newBoundsWidthOffset,
                               height: bounds.height)
        
        var textRect = super.leftViewRect(forBounds: newBounds)
        textRect.origin.x += UnderlineTextFieldConstants.newBoundsTextRectXOffset
        return textRect
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + UnderlineTextFieldConstants.forBoundsTextRectOriginXOffset,
                      y: bounds.origin.y + UnderlineTextFieldConstants.forBoundsTectRectOriginYOffset,
                      width: bounds.width + UnderlineTextFieldConstants.forBoundsTectRectOriginYOffset,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + UnderlineTextFieldConstants.forBoundsTextRectOriginXOffset,
                      y: bounds.origin.y + UnderlineTextFieldConstants.forBoundsTectRectOriginYOffset,
                      width: bounds.width + UnderlineTextFieldConstants.forBoundsTectRectOriginYOffset,
                      height: bounds.height)
    }
    
    func setup() {
        let border = CALayer()
        let width: CGFloat = 1.2
        border.borderColor = UIColor.white.cgColor
        font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        autocorrectionType = .no
    }
}

extension UnderlineTextField {
    
    func setupField(with textColor: UIColor, tintColor: UIColor) {
        self.textColor = textColor
        self.tintColor = tintColor
    }
    
    func setLeftView(with image: UIImage, and tintColor: UIColor) {
        leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 26, height: 22))
        let icon = image.withRenderingMode(.alwaysTemplate)
        imageView.image = icon
        imageView.tintColor  = tintColor
        leftView = imageView
    }
    
    func setPlaceholder(with text: String, and font: UIFont) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.5), range: NSRange(location: 0, length: attributedString.length))
        let fontAttribute = [NSFontAttributeName: font]
        attributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: attributedString.length))
        attributedPlaceholder = attributedString
    }
    
    func setupPasswordField() {
        setupField(with: .white, tintColor: .white)
        setLeftView(with: #imageLiteral(resourceName: "new-lock"), and: .white)
        setPlaceholder(with: "PASSWORD", and: UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin))
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        accessibilityLabel = "password-field"
        setup()
    }
    
    func setupEmailField() {
        setupField(with: .white, tintColor: .white)
        setLeftView(with: #imageLiteral(resourceName: "letter-2"), and: .white)
        setPlaceholder(with: "EMAIL", and: UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin))
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text.lowercased())
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        accessibilityLabel = "email-field"
        setup()
    }
    
    func setupUserField() {
        setupField(with: .white, tintColor: .white)
        setLeftView(with: #imageLiteral(resourceName: "user"), and: .white)
        setPlaceholder(with: "Username", and: UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin))
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
            setup()
        }
    }
}
