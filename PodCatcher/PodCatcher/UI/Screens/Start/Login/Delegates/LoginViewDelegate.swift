import Foundation

protocol LoginViewDelegate: class {
    func facebookLoginButtonTapped() 
    func userEntryDataSubmitted(with username: String, and password: String)
}
