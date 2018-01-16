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
        setTitle(title, for: .normal)
        backgroundColor = UIColor(red:0.47, green:0.78, blue:1.00, alpha:1.0)
            //UIColor(red:0.35, green:0.69, blue:0.93, alpha:1.0)
            ///UIColor.lightGray
        contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        layer.borderColor = UIColor.lightGray.cgColor
            //UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.setShadow(for: UIColor(red:0.47, green:0.78, blue:1.00, alpha:1.0))
    }
    
    
}
