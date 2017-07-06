import UIKit
import FBSDKLoginKit
import Firebase

// MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    func facebookLoginButtonTapped() {
        loginWithFacebook()
    }
    
    
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
    
    func loginWithFacebook() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.downloadIndicator.hideActivityIndicator(viewController: self)
                    print(error.localizedDescription)
                    
                    return
                } else {
                    if let user = user {
                        let podUser = PodCatcherUser(username: user.displayName ?? "unknown", emailAddress: user.email ?? "unknown")
                        self.delegate?.successfulLogin(for: podUser)
                    }
                }
            })
        }
    }
}
