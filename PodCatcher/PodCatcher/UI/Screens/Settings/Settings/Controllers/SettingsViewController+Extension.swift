import UIKit

// MARK: - GuestUserViewDelegate

extension SettingsViewController: GuestUserViewDelegate {
    func signIntoAccount(tapped: Bool) {
        delegate?.guestUserSignIn(tapped: true)
    }
}

// MARK: - SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    
    func settingOne(tapped: Bool) {
        delegate?.settingOne(tapped: tapped)
    }
    
    func settingTwo(tapped: Bool) {
        delegate?.settingTwo(tapped: tapped)
    }
}
