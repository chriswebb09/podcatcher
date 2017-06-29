import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let titleFontAttribute = UIFont(name:"Avenir", size: 16) as Any
        let buttonFontAttribute = UIFont(name:"Avenir", size: 18) as Any
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: buttonFontAttribute], for: .normal)
        UINavigationBar.appearance().tintColor = UIColor.mainColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: titleFontAttribute,
            NSForegroundColorAttributeName: UIColor.mainColor,
            NSBackgroundColorAttributeName: UIColor.white
        ]
    }
    
    func setupDefaultUI() {
        
    }
}
