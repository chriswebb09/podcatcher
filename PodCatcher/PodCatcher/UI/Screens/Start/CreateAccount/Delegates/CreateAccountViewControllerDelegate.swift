import Foundation

protocol CreateAccountViewControllerDelegate: class {
    func submitButton(tapped: Bool)
    func navigateBack(tapped: Bool)
    func successfulLogin(for user: PodCatcherUser)
}
