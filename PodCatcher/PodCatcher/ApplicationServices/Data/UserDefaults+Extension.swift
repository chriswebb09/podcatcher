//
//  UserDefaults+Extension.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/25/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

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
}
