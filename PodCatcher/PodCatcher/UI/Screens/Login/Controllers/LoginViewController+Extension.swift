import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate, LoadingViewProtocol {
    
    func userEntryDataSubmitted(with username: String, and password: String) {
        showLoadingView(loadingPop: loadingPop, controller: self)
        PodCatcherUserDataStore.userSignIn(username: username, password: password) { user, error in
            dump(user)
            dump(error)
            
            if let error = error {
                print(error.localizedDescription)
                self.hideLoadingView(loadingPop: self.loadingPop, controller: self)
            }
            if let user = user {
                self.delegate?.successfulLogin(for: user)
            }
        }
    }
}
