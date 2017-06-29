import UIKit

class FavoritePodcastsBuilder {
    
}

extension SettingsTabCoordinator: SettingsViewControllerDelegate {
    
    func settingOne(tapped: Bool) {

    }
    
    func settingTwo(tapped: Bool) {
        let updateAccountViewController = UpdateAccountViewController()
        updateAccountViewController.dataSource = dataSource
        updateAccountViewController.delegate = self
        navigationController.viewControllers.append(updateAccountViewController)
    }
    
    func guestUserSignIn(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
}

extension SettingsTabCoordinator: UpdateAccountViewControllerDelegate {
    func updated(username: String) {
        print(username)
    }
    
    func updated(email: String) {
        print(email)
    }
}
