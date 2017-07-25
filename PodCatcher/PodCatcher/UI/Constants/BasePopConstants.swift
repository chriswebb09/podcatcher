import UIKit

struct BasePopoverAlertConstants {
    static let popViewX = UIScreen.main.bounds.width / 2
    static let popViewY = UIScreen.main.bounds.height / 2
    static let containerOpacity: Float = 0.4
}

struct DetailViewConstants {
    static let heightMultiplier: CGFloat = 0.2
    static let fieldWidth: CGFloat = 0.9
    static let borderWidth: CGFloat = 2
    static let largeCornerRadius: CGFloat = 5
    static let cornerRadius: CGFloat = 2
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let mainColor: UIColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
    static let titleFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 18)!
}

