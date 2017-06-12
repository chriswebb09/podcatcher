import UIKit

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    
    func userEntryDataSubmitted(with username: String, and password: String) {
        UserDataAPIClient.loginToAccount(email: username, password: password) { user in
            let user = PodCatcherUser(username: "test", emailAddress: user.email!)
            self.delegate?.successfulLogin(for: user)
        }
//        UserLoginAPIClient.login(with: username, and: password) { data in
//            if data.0 == true {
//                guard let userData = data.1 else { return }
//                guard let testUsename = userData["username"] as? String else { return }
//                guard let testEmail = userData["email"] as? String else { return }
//                guard let testCasts = userData["casters"] as? [Caster] else { return }
//                guard let customGenre = userData["customGenre"] as? [String] else { return }
//                let user = PodCatcherUser(username: testUsename, emailAddress: testEmail)
//                user.customGenres = customGenre
//                user.casts = testCasts
//                print(user.casts)
//                print(user.casts)
//                self.delegate?.successfulLogin(for: user)
//            } 
//        }
    }
}
