import UIKit

extension SettingsTabCoordinator: SettingsViewControllerDelegate {
    func guestUserSignInTapped(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func settingTwoTapped(tapped: Bool) {
        let updateAccountViewController = UpdateAccountViewController()
        updateAccountViewController.dataSource = dataSource
        updateAccountViewController.delegate = self
        navigationController.viewControllers.append(updateAccountViewController)
    }
    
    func settingOneTapped(tapped: Bool) {
        let updateAccountViewController = FavoritePodcastsViewController(dataSource: dataSource)
        updateAccountViewController.dataSource = dataSource
      //  updateAccountViewController.delegate = self
        navigationController.viewControllers.append(updateAccountViewController)
    }
}

extension SettingsTabCoordinator: UpdateAccountViewControllerDelegate {
    func updated(username: String) {
        print(username)
    }
    
    func updated(email: String) {
        
    }
}
