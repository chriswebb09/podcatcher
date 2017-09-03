import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont(name: "Avenir-Book", size: 18)!
            //Avenir-Medium
            //UIFont(name: "Avenir-Book", size: 16)!
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().backgroundColor = .black
        let nav = UINavigationBar.appearance()
        nav.barTintColor = .black
        nav.tintColor = .white
        let tabbar = UITabBar.appearance()
        tabbar.barTintColor = .clear
        tabbar.tintColor = Colors.brightHighlight
        
        let customFont = UIFont(name: "Avenir-Medium", size: 18.0)!
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont], for: .normal)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: titleFontAttribute,
            NSForegroundColorAttributeName: UIColor.white
        ]
        
       // UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset.init(horizontal: 10, vertical: 0), for: UIBarMetrics.default)
    }
}
