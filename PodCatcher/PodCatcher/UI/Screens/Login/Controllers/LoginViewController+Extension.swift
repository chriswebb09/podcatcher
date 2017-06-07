import UIKit

extension LoginViewController: LoginViewDelegate {
    
    func userEntryDataSubmitted(with username: String, and password: String) {
        UserLoginAPIClient.login(with: username, and: password) { data in
            if data.0 == true {
                guard let userData = data.1 else { return }
                guard let testUsename = userData["username"] as? String else { return }
                guard let testEmail = userData["email"] as? String else { return }
                let user = PodCatcherUser(username: testUsename, emailAddress: testEmail)
                self.delegate?.successfulLogin(for: user)
            } 
        }
    }
    
    func usernameFieldDidAddText(text: String?) {
        guard let text = text else { return }
        print(text)
    }
}
