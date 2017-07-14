import UIKit

extension SettingsTabCoordinator: SettingsViewControllerDelegate {
    func guestUserSignIn(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
}
