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
