//
//  PodCatcherUserDataStore.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

class PodCatcherUserDataStore {
    
    
    static func userSignIn(username: String, password: String, completion: @escaping (PodCatcherUser) -> Void) {
        UserDataAPIClient.loginToAccount(email: username, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
               
                return
            }
            PullData.pullFromDatabase { pulled in
                guard let user = user else { return }
                pulled.username = user.uid
                pulled.userId = user.uid
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(pulled)
                }
            }
        }
    }
}
