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
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.alpha = 0.8
        return button
    }
}
