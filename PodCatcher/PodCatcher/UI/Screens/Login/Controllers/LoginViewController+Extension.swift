import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {

    func userEntryDataSubmitted(with username: String, and password: String) {
        downloadIndicator.showActivityIndicator(viewController: self)
        PodCatcherUserDataStore.userSignIn(username: username, password: password) { user, error in
            if let error = error {
                self.downloadIndicator.hideActivityIndicator(viewController: self)
                print(error.localizedDescription)
            }
            if let user = user {
                self.delegate?.successfulLogin(for: user)
            }
        }
    }
}
