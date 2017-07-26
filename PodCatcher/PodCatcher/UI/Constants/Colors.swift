import UIKit

struct Colors {
    static let highlight = UIColor(red:0.55, green:0.61, blue:0.84, alpha:1.0)
    static let lightHighlight = UIColor(red:0.60, green:0.68, blue:0.99, alpha:1.0)
    static let brightHighlight = UIColor(red:0.41, green:0.47, blue:0.91, alpha:1.0)
    static let offWhite = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.0)
    static let lightText = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    static let darkCharcoal = UIColor(red:0.20, green:0.24, blue:0.23, alpha:1.0)
    static let charcoal = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.0)
    static let lightCharcoal = UIColor(red:0.44, green:0.45, blue:0.50, alpha:1.0)
    static let nearWhite = UIColor(red:0.98, green:0.98, blue:1.00, alpha:1.0)
}

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        UINavigationBar.appearance().tintColor = .white
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = .black
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: titleFontAttribute,
            NSForegroundColorAttributeName: UIColor.white,
            NSBackgroundColorAttributeName: UIColor.black
        ]
    }
}

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

struct UnderlineTextFieldConstants {
    static let newBoundsOriginXOffset: CGFloat = 22
    static let newBoundsOriginYOffset: CGFloat = 8
    static let newBoundsWidthOffset: CGFloat = 12
    static let newBoundsTextRectXOffset: CGFloat = 5
    static let forBoundsTextRectOriginXOffset: CGFloat = 50
    static let forBoundsTectRectOriginYOffset: CGFloat = 12
}
