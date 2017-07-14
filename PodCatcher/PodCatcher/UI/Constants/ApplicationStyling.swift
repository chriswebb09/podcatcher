import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        //let buttonFontAttribute = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        let tabBar = UITabBar.appearance()
        
        tabBar.barTintColor = UIColor.clear
      //  UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: buttonFontAttribute], for: .normal)
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
