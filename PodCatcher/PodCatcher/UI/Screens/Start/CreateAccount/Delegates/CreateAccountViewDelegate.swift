import Foundation

protocol CreateAccountViewDelegate: class {
    func submitButton(tapped: Bool)
    func signupWith(email: String, password: String)
    func signupWithFacebook(tapped: Bool)
    func navigateBack(tapped: Bool)
}
