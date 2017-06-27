import UIKit

class TabBarCoordinator: TabControllerCoordinator, Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    
    var type: CoordinatorType = .tabbar
    
    var tabBarController: TabBarController
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
        let tabCoordinator = SettingsTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupFavoritesCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = FavoritesTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupMediaCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = MediaTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        dump(dataSource)
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func start() {
        setup()
        window.rootViewController = tabBarController
    }
    
    func setup() {
        tabBarController.setTabTitles(controllers: [childCoordinators[0].navigationController, childCoordinators[1].navigationController, childCoordinators[2].navigationController])
    }
}
