import UIKit

protocol LoginViewControllerDelegate: class {
    func successfulLogin(for user: PodCatcherUser) 
}
