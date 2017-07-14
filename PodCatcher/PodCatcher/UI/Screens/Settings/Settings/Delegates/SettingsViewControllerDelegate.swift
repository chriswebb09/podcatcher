import Foundation

protocol SettingsViewControllerDelegate: class {
    func guestUserSignIn(tapped: Bool)
}


protocol SettingCellDelegate: class {
    func onTap()
    func cellTapped(with label: String)
}
