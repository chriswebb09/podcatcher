import Firebase

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
            user.customGenres = keys
            completion(user)
            
        }) { error in
            print(error.localizedDescription)
        }
    }
}
