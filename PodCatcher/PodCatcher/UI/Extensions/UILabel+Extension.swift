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
    
    static func setupInfoLabel() -> UILabel {
        let infoLabel: UILabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        infoLabel.text = "Add to your playlist..."
        return infoLabel
    }
}



