import Foundation

protocol LoginViewDelegate: class {
    func submitButtonTapped()
    func usernameFieldDidAddText(text: String?)
}
