import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont(name:"AvenirNext-Regular", size: 16) as Any
        let buttonFontAttribute = UIFont(name:"AvenirNext-Regular", size: 18) as Any
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
