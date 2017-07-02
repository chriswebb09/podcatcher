import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {

    func userEntryDataSubmitted(with username: String, and password: String) {
        showLoadingView(loadingPop: loadingPop)
        PodCatcherUserDataStore.userSignIn(username: username, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                self.hideLoadingView(loadingPop: self.loadingPop)
            }
            if let user = user {
                self.delegate?.successfulLogin(for: user)
            }
        }
    }
}
