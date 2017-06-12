//
//  NetworkDatabaseManager.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import Firebase

class NetworkDataManager {
    var ref: DatabaseReference!
    
    init() {
         ref = Database.database().reference()
    }
   
    func setupUserId(email: String, id: String) {
        self.ref.child("users").setValue(id)
        self.ref.child("users").child(id).setValue(["email": email])
    }
    
    func setupUsername(username: String, id: String) {
        self.ref.child("users").child(id).setValue(["username": username])
    }
    
}
