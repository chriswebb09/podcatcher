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




