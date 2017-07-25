import UIKit

struct MenuViewConstants {
    static let sharedHeightMultiplier: CGFloat = 0.2
    static let backgroundColor = UIColor(red:0.09, green:0.14, blue:0.31, alpha:1.0)
    static let alpha: CGFloat = 0.98
    static let optionBorderWidth: CGFloat =  1
}

struct MenuOptionViewConstants {
    static let optionLabelCenterXOffset: CGFloat = UIScreen.main.bounds.width * 0.025
    static let optionLabelHeightMultiplier: CGFloat = 0.9
    static let optionLabelWidthMultiplier: CGFloat = 0.8
    static let iconViewCenterXOffset: CGFloat = UIScreen.main.bounds.width * 0.23
    static let iconViewHeightAnchor: CGFloat = 0.35
    static let iconViewWidthAnchor: CGFloat = 0.5
}
