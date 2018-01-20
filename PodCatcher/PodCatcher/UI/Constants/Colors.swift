import UIKit

enum Style {
    
    enum Font {
        static let main = UIFont(name: "AvenirNext-Regular", size: 16)
        enum PlaylistCell {
            static let title = UIFont(name: "AvenirNext-Regular", size: 17)
            static let items = UIFont(name: "AvenirNext-UltraLight", size: 14)
        }
    }
    
    enum Color {
        static let main = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
        static let background = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
        static let button = UIColor(red:0.10, green:0.71, blue:1.00, alpha:1.0)
        static let tableViewBackground = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        
        enum Highlight {
            static let highlight = UIColor(red:0.55, green:0.61, blue:0.84, alpha:1.0)
            static let lightHighlight = UIColor(red:0.60, green:0.68, blue:0.99, alpha:1.0)
            static let brightHighlight = UIColor(red:0.41, green:0.47, blue:0.91, alpha:1.0)
        }
        
        enum Charcoal {
            static let lightCharcoal = UIColor(red:0.44, green:0.45, blue:0.50, alpha:1.0)
            static let darkCharcoal = UIColor(red:0.20, green:0.24, blue:0.23, alpha:1.0)
            static let charcoal = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.0)
        }
        
        enum Light {
            static let nearWhite = UIColor(red:0.98, green:0.98, blue:1.00, alpha:1.0)
            static let offWhite = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.0)
            static let lightText = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        }
        
        enum Alert {
            static let cancelButton = UIColor(red:0.88, green:0.35, blue:0.35, alpha:1.0)
        }
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
