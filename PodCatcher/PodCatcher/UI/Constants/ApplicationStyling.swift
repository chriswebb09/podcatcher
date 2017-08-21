import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().backgroundColor = .black
        let nav = UINavigationBar.appearance()
        nav.barTintColor = .black
        nav.tintColor = .white
        
        let tabbar = UITabBar.appearance()
        tabbar.barTintColor = .clear
        tabbar.tintColor = Colors.brightHighlight
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: titleFontAttribute,
            NSForegroundColorAttributeName: UIColor.white
        ]
        
//     
//        let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
//
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)

    }
}
