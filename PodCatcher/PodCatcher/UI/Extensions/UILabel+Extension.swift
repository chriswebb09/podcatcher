import UIKit

extension UILabel {
    
    static func setupInfoLabel(infoText: String) -> UILabel {
        let infoLabel: UILabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        if let font = UIFont(name: "Avenir-Book", size: 20) {
            infoLabel.font = font
        }
        infoLabel.text = infoText
        return infoLabel
    }
}

extension UICollectionViewCell: Reusable { }
