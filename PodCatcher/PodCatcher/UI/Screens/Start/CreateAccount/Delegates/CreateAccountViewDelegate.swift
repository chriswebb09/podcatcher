import Foundation

protocol CreateAccountViewDelegate: class {
    func submitButton(tapped: Bool)
    func signupWithFacebook(tapped: Bool)
    func navigateBack(tapped: Bool)
}
