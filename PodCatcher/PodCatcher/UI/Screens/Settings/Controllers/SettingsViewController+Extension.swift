import UIKit

// MARK: - SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    
    func settingOneTapped() {
        print("One")
        print(dataSource.user?.favoriteCasts)
        delegate?.settingOneTapped(tapped: true)
    }
    
    func settingTwoTapped() {
        print("two")
        delegate?.settingTwoTapped(tapped: true)
    }
}
