import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    
    func userEntryDataSubmitted(with username: String, and password: String) {
        UserDataAPIClient.loginToAccount(email: username, password: password) { user in
            PullData.pullFromDatabase { pulled in
                pulled.username = user.uid
                pulled.userId = user.uid
                self.delegate?.successfulLogin(for: pulled)
            }
        }
    }
}
