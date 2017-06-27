import Foundation

protocol LoginViewDelegate: class {
    func userEntryDataSubmitted(with username: String, and password: String)
}
