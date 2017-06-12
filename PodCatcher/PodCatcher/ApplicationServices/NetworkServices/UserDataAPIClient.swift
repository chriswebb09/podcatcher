//
//  UserDataAPIClient.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Firebase

class UserDataAPIClient {

    
    static func createUserAccount(email: String, password: String) {
        var networkData = NetworkDataManager()
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            guard let uid = user?.uid else { return }
            networkData.setupUserId(email: email, id: uid)
            dump(user)
        }
    }
    
    static func loginToAccount(email: String, password: String, completion: @escaping(User) -> Void) {
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            guard let user = user else { return }
            completion(user)
        }
    }
}
