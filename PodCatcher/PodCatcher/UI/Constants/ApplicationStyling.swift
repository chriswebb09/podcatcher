import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
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
