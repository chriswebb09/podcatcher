//
//  Store.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

public final class Store {
    static let changedNotification = Notification.Name("StoreChanged")
    
    func save(_ notifying: Episode, userInfo: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: Store.changedNotification, object: notifying, userInfo: userInfo)
    }
}
