import Foundation

protocol LoginViewDelegate: class {
    func navigateBack(tapped: Bool)
    func facebookLoginButtonTapped() 
    func userEntryDataSubmitted(with username: String, and password: String)
}
