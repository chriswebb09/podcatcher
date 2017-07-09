import UIKit

protocol LoginViewControllerDelegate: class {
    func successfulLogin(for user: PodCatcherUser)
    func navigateBack(tapped: Bool)
}
