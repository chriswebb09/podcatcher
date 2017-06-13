import Foundation

protocol UpdateAccountViewControllerDelegate: class {
    func updated(username: String)
    func updated(email: String)
}
