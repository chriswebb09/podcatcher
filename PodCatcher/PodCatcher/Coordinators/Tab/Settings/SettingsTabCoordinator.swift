import UIKit

final class SettingsTabCoordinator: NavigationCoordinator {
    
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
    func guestUserSignIn(_ tapped: Bool) {
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
}
