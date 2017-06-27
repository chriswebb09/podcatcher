import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        let fontAttribute = UIFont(name:"Avenir", size: 18) as Any
        UINavigationBar.appearance().tintColor = UIColor.mainColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: fontAttribute,
            NSForegroundColorAttributeName: UIColor.mainColor,
            NSBackgroundColorAttributeName: UIColor.white
        ]
    }
}
