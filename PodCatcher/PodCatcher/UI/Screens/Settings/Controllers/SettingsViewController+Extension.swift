import UIKit

extension SettingsViewController: SettingsViewDelegate {
    
    func settingOneTapped() {
        print("One")
        delegate?.settingOneTapped(tapped: true)
    }
    
    func settingTwoTapped() {
        print("two")
        delegate?.settingTwoTapped(tapped: true)
    }
}
