import Foundation

protocol LoginViewDelegate: class {
    func loginViewFocus() 
    func userEntryDataSubmitted(with username: String, and password: String)
}
