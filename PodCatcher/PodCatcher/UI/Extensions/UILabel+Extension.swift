import UIKit

extension UILabel {
    
    static func setupInfoLabel(infoText: String) -> UILabel {
        let infoLabel: UILabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        if let font = UIFont(name: "AvenirNext-Regular", size: 20) {
            infoLabel.font = font
        }
        infoLabel.text = infoText
        return infoLabel
    }
}

extension UICollectionViewCell: Reusable { }

extension UIButton {
    
    static func setupSubscribeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe", for: .normal)
        // button.addTarget(self, action: #selector(subscribeToFeed), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        
        button.tintColor = .white
        button.backgroundColor = UIColor(red:0.36, green:0.60, blue:0.76, alpha:1.0)
        //UIColor(red:0.47, green:0.78, blue:1.00, alpha:1.0)
        //UIColor(red:0.27, green:0.18, blue:0.85, alpha:1.0)
        //UIColor(red:0.34, green:0.25, blue:0.82, alpha:1.0)
        //UIColor(red:0.39, green:0.30, blue:0.89, alpha:1.0)
        //.darkGray
        button.alpha = 0.8
        return button
    }
    
    convenience init(pill title: String) {
        self.init(type: .custom)
        
        
        backgroundColor = UIColor(red:0.47, green:0.78, blue:1.00, alpha:1.0)
        contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.setShadow(for: UIColor(red:0.47, green:0.78, blue:1.00, alpha:1.0))
        let customFont = UIFont(name: "AvenirNext-Regular", size: 14)!
        let attributes = [
            NSAttributedStringKey.font : customFont,
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
      //  UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0)
        let attributedtitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributedtitle, for: .normal)
        
        //        self.setAttributedTitle( for: .normal)
        //
        //
        //        setTitle(title, for: .normal)
        
        //        var title = NSAttributedString(string: "NSAttributedString", attributes: attributes)
        //        let attributedText = NSAttributedString(attributedString: <#T##NSAttributedString#>)
        //        self.setAttributedTitle([NSAttributedStringKey.foregroundColor: UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0), NSAttributedStringKey.font: customFont], for: .normal)
        //setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0), NSAttributedStringKey.font: customFont], for: .selected)
        
    }
    
    
}
