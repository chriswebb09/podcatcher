import UIKit

class ApplicationStyling {
    
    static func setupUI() {
        
        let titleFontAttribute = UIFont(name: "Avenir-Book", size: 18)!
        
        let nav = UINavigationBar.appearance()
        
        nav.barTintColor = UIColor(red:0.34, green:0.62, blue:0.81, alpha:1.0)
        //UIColor(red:0.35, green:0.69, blue:0.93, alpha:1.0)
        nav.tintColor = .white
        
        let tabbar = UITabBar.appearance()
        //        tabbar.barTintColor = UIColor(red:0.39, green:0.45, blue:0.50, alpha:1.0)
        //
        
        
        //tabbar.tintColor = UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0)
        
        
        tabbar.barTintColor = Style.Color.Charcoal.darkCharcoal
            //UIColor.black
        let tabItem = UITabBarItem.appearance()
        tabbar.tintColor = UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0)
            //UIColor(red:0.87, green:0.94, blue:0.99, alpha:1.0)
            //UIColor(red:0.39, green:0.45, blue:0.50, alpha:1.0)
        // tabItem.selectedImage = tabItem.image?.withRenderingMode(.alwaysTemplate)
        tabbar.unselectedItemTintColor = UIColor(red:0.87, green:0.94, blue:0.99, alpha:1.0)
            //UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0)
        //UIColor(red:0.39, green:0.45, blue:0.50, alpha:1.0)
        
        //tabbar.tintColor = UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0)
        //        let tabbar = UITabBar.appearance()
        //
        //UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        //UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        //UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        //
        //UIColor(red:0.31, green:0.31, blue:0.93, alpha:1.0)
        //UIColor(red:0.37, green:0.67, blue:0.89, alpha:1.0)
        //UIColor(red:0.40, green:0.72, blue:0.95, alpha:1.0)
        //UIColor(red:0.35, green:0.69, blue:0.93, alpha:1.0)
        //       x
        //.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState:UIControlState.Selected)
        // let customFont = UIFont(name: "Avenir-Medium", size: 18.0)!
        let customFont = UIFont(name: "AvenirNext-Regular", size: 12.0)!
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: customFont], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.87, green:0.94, blue:0.99, alpha:1.0), NSAttributedStringKey.font: customFont], for: .normal)
        //UIColor(red:0.35, green:0.69, blue:0.93, alpha:1.0)
        // UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: customFont], for: .normal)
        //        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.35, green:0.69, blue:0.93, alpha:1.0)], for: .selected)
        //
        
        //  UIColor(red:0.31, green:0.31, blue:0.93, alpha:1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0), NSAttributedStringKey.font: customFont], for: .selected)
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.77, green:0.91, blue:1.00, alpha:1.0), NSAttributedStringKey.font: customFont], for: .selected)
        // IColor(red:0.35, green:0.69, blue:0.93, alpha:1.0)
        //      UIColor(red:0.37, green:0.67, blue:0.89, alpha:1.0)
        // UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        // UIBarButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()] , forState:UIControlState.Selected)
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: titleFontAttribute,
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        nav.backItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: customFont], for: .normal)
        UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset.init(horizontal: 10, vertical: 0), for: UIBarMetrics.default)
        
        
    }
}
