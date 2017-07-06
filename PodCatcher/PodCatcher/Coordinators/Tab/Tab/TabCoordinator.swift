import UIKit

class TabCoordinator: NavigationCoordinator {
    
    var type: CoordinatorType = .tabbar
    weak var delegate: CoordinatorDelegate?
    var dataSource: BaseMediaControllerDataSource!
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
    
    }
    
    func addChild(viewController: UIViewController) {
        navigationController.viewControllers.append(viewController)
    }
}
