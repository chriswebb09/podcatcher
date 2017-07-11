import Foundation

protocol CreateAccountViewControllerDelegate: class {
    func submitButton(tapped: Bool)
    func navigateBack(tapped: Bool)
}
