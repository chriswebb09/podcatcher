import Firebase

class UpdateData {
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
            let user = PodCatcherUser(username: username, emailAddress: email)
            completion(user)
            
        }) { error in
            print(error.localizedDescription)
        }
    }
}

final class SetData {
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func setup(email: String, id: String) {
        let usersRef = ref.child("users")
        let userRef = usersRef.child(id)
        let date = Date()
        userRef.child("joinDate").setValue(String(describing: date))
        userRef.child("email").setValue(email.lowercased())
    }
    
    func setupUsername(username: String, id: String) {
        self.ref.child("users").child(id).setValue(["username": username])
    }
}


class AuthClient {
    
    static func createUserAccount(email: String, password: String) {
        let setData = SetData()
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            guard let uid = user?.uid else { return }
            setData.setup(email: email, id: uid)
        }
    }
    
    static func loginToAccount(email: String, password: String, completion: @escaping(User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            guard let user = user else {
                completion(nil, error)
                return
            }
            completion(user, nil)
        }
    }
}

