import Foundation

protocol UpdateAccountViewDelegate: class {
    func usernameUpdated(username: String)
    func emailUpdated(email: String)
}
