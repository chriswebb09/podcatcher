//
//  ReachabilityNotification.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/25/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ReachabilitySwift

class ReachabilityNotification {
    
    var reachability: Reachability?
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }

}
