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
}

