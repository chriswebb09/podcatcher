import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    
    func userEntryDataSubmitted(with username: String, and password: String) {
        self.showLoadingView(loadingPop: self.loadingPop)
        UserDataAPIClient.loginToAccount(email: username, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                self.hideLoadingView()
                return
            }
            PullData.pullFromDatabase { pulled in
                guard let user = user else { return }
                dump(pulled)
                pulled.username = user.uid
                pulled.userId = user.uid
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.delegate?.successfulLogin(for: pulled)
                }
            }
        }
    }
}
