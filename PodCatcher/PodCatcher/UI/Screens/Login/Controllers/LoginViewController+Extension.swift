import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate, LoadingViewProtocol {
    
    func userEntryDataSubmitted(with username: String, and password: String) {
        showLoadingView(loadingPop: loadingPop, controller: self)
        PodCatcherUserDataStore.userSignIn(username: username, password: password) { user in
            self.delegate?.successfulLogin(for: user)
        }
    }
}
