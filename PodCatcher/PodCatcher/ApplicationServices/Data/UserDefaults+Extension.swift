import Foundation

extension UserDefaults {
    
    static func loadDefaultOnFirstLaunch() -> Bool {
        let key = "hasLaunchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: key)
        if launchedBefore == false {
            UserDefaults.standard.set(true, forKey: key)
            return false
        }
        return true
    }
    
    static func loadOnAuth() -> Bool  {
        if let lastUpdated = UserDefaults.standard.object(forKey: "topItems") as? Date {
            if lastUpdated > Date(timeIntervalSinceNow: -86400) {
                return true
            }
        }
        return false
    }
    
    static func saveSubscriptions(subscriptions: [String]) {
        UserDefaults.standard.set(subscriptions, forKey: "subscriptions")
    }
    
    static func loadSubscriptions() -> [String] {
        if UserDefaults.isKeyPresentInUserDefaults(key: "subscriptions") {
            let subscriptions = UserDefaults.standard.array(forKey: "subscriptions") as! [String]
            return subscriptions
        }
        return []
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
        
       // NSUserDefaults.standardUserDefaults().setObject(myArray, forKey: "\(identity.text!)listA")
      //  let tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("\(identity.text!)listA")
//        let launchedBefore = UserDefaults.standard.bool(forKey: key)
//        if launchedBefore == false {
//            UserDefaults.standard.set(true, forKey: key)
//            return false
//        }
//        return true
    //}
}

