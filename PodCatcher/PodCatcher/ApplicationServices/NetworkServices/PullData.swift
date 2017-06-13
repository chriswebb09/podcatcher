import Firebase

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
