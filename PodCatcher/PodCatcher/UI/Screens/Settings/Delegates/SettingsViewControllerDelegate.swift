import Foundation

protocol SettingsViewControllerDelegate: class {
    func settingOneTapped(tapped: Bool)
    func settingTwoTapped(tapped: Bool)
    func guestUserSignInTapped(tapped: Bool)
}
