import UIKit

class SettingsTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let settingsViewController = navigationController.viewControllers[0] as! SettingsViewController
        settingsViewController.delegate = self
    }
}

extension SettingsTabCoordinator: SettingsViewControllerDelegate {
    
    func settingTwoTapped(tapped: Bool) {
        let updateAccountViewController = UpdateAccountViewController()
        updateAccountViewController.dataSource = dataSource
        updateAccountViewController.delegate = self
        navigationController.viewControllers.append(updateAccountViewController)
    }

    func settingOneTapped(tapped: Bool) {
        let updateAccountViewController = UpdateAccountViewController()
        updateAccountViewController.dataSource = dataSource
        updateAccountViewController.delegate = self
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
