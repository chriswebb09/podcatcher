import Firebase

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
    }
    
    static func update(_ time: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("users/\(userID)/playtime/").setValue(time)
    }
    
    static func update(_ username: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("users/\(userID)/username/").setValue(username)
    }
}

class PullData {
    
    static func pullFromDatabase(completion: @escaping (PodCatcherUser) -> Void) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let genres = value?["genres"] as? NSDictionary
            let user = PodCatcherUser(username: username, emailAddress: email)
            let keys = genres?.allKeys as! [String]
            for key in keys {
                guard let genre = genres?[key] else { return }
                let data = genre as! NSDictionary
                for (_, n) in data.enumerated() {
                    print(n.value)
                }
            }
            user.customGenres = keys
            completion(user)
        }) { error in
            print(error.localizedDescription)
        }
        
    }
}
