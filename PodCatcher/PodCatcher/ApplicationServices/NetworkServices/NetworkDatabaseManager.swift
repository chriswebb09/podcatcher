//
//  NetworkDatabaseManager.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import Firebase

class SetData {
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func setup(email: String, id: String) {
        let usersRef = ref.child("users")
        let userRef = usersRef.child(id)
        let date = Date()
        userRef.child("joinDate").setValue(String(describing: date))
        userRef.child("email").setValue(email)
    }
    
    func setup(userPlaytime: Int, id: String) {
        self.ref.child("users/\(id)/playtime").setValue(userPlaytime)
    }
    
    func setupUsername(username: String, id: String) {
        self.ref.child("users").child(id).setValue(["username": username])
    }
}

class PullData {
    
    static func pullFromDatabase(completion: @escaping (PodCatcherUser) -> Void) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let genres = value?["genres"] as? String ?? ""
            let user = PodCatcherUser(username: username, emailAddress: email)
            user.customGenres = [genres]
            completion(user)
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
    }
}

class UpdateData {
    
    static func update(_ genres: [String]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        for genre in genres {
            ref.child("users/\(userID)/genres").setValue(genre)
        }
    }
    
    static func update(_ genre: (String, String)) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("users/\(userID)/genres/\(genre.0)").childByAutoId().setValue(genre.1)
        //  ref.child("users/\(userID)/genres/\(genre.0)").setValue(genre.1)
    }
}
