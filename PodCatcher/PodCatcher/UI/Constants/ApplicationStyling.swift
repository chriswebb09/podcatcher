import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().backgroundColor = .black
        let nav = UINavigationBar.appearance()
        nav.barTintColor = .black
        nav.tintColor = .white
        let tabbar = UITabBar.appearance()
        tabbar.barTintColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: titleFontAttribute,
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
    }
}
