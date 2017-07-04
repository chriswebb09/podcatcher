import Foundation

protocol SettingsViewControllerDelegate: class {
    func settingOne(tapped: Bool)
    func settingTwo(tapped: Bool)
    func guestUserSignIn(tapped: Bool)
}
