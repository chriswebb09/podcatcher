import Foundation

protocol SettingsViewControllerDelegate: class {
    func guestUserSignIn(tapped: Bool)
}

protocol SettingCellDelegate: class {
    func cellTapped(with label: String)
}
