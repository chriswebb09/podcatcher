import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        let buttonFontAttribute = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: buttonFontAttribute], for: .normal)
        UINavigationBar.appearance().tintColor = Colors.brightHighlight
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: titleFontAttribute,
            NSForegroundColorAttributeName: UIColor.darkGray,
            NSBackgroundColorAttributeName: UIColor.lightText
        ]
    }
}
