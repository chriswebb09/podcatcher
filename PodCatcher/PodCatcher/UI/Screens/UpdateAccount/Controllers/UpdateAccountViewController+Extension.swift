import UIKit

extension UpdateAccountViewController: UpdateAccountViewDelegate {
    
    func emailUpdated(email: String) {
        delegate?.updated(email: email)
    }
    
    func usernameUpdated(username: String) {
        UpdateData.update(username)
        delegate?.updated(username: username)
    }
}
