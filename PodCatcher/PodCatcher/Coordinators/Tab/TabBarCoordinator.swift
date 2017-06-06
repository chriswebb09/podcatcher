import UIKit

class TabBarCoordinator: TabControllerCoordinator, Coordinator {
    
    var type: CoordinatorType = .tabbar
    
    var tabBarController: TabBarController
    
    weak var delegate: CoordinatorDelegate?
    
    var window: UIWindow!
    
    var childCoordinators: [NavigationCoordinator] = []
    
    required init(tabBarController: TabBarController) {
        self.tabBarController = tabBarController
    }
    
    convenience init(tabBarController: TabBarController, window: UIWindow) {
        self.init(tabBarController: tabBarController)
        self.window = window
    }
    
    func start(viewController: UIViewController) {
        // Fix
    }
    
    func setupSettingsCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        var tabCoordinator = TabCoordinator(navigationController: navigationController)
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupMediaCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        var tabCoordinator = MediaTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    
    func start() {
        setup()
        window.rootViewController = tabBarController
    }
    
    func setup() {
        tabBarController.setTabTitles(controllers: [childCoordinators[0].navigationController, childCoordinators[1].navigationController])
    }
}


