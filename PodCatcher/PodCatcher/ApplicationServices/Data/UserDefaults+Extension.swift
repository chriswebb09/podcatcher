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
    
    static func loadAudioFilesFor(feed: String) -> [String] {
        if UserDefaults.isKeyPresentInUserDefaults(key: feed) {
            let subscriptions = UserDefaults.standard.array(forKey: feed) as! [String]
            return subscriptions
        }
        return []
    }
    
    static func saveAudioFile(location: String, forFeed: String) {
        var audioFiles = loadAudioFilesFor(feed: forFeed)
        audioFiles.append(location)
        UserDefaults.standard.set(audioFiles, forKey: forFeed)
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
}

