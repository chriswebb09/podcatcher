import UIKit
import FBSDKLoginKit
import Firebase

// MARK: - CreateAccountViewDelegate

extension CreateAccountViewController: CreateAccountViewDelegate {
    
    func signupWithFacebook(tapped: Bool) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                self.view.layoutSubviews()
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else { print("Failed to get access token"); return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { user, error in
                if let error = error {
                    self.downloadIndicator.hideActivityIndicator(viewController: self)
                    print(error.localizedDescription)
                    return
                } else {
                    if let user = user {
                        let podUser = PodCatcherUser(username: user.displayName ?? "unknown", emailAddress: user.email ?? "unknown")
                        self.delegate?.successfulLogin(for: podUser)
                    }
                }
            }
        }
    }
    
    func submitButton(tapped: Bool) {
        delegate?.submitButton(tapped: tapped)
    }
    
    func navigateBack(tapped: Bool) {
        delegate?.navigateBack(tapped: tapped)
        navigationController?.popViewController(animated: false)
    }
}
