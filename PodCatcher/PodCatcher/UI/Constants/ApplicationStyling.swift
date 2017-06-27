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
        
//        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.textColor]
//        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.textColor
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for tracks...", attributes: [NSForegroundColorAttributeName: UIColor.white])
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
    
    func setupDefaultUI() {
        
    }
}
