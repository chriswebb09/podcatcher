import UIKit

class TabBarCoordinator: TabControllerCoordinator {
    
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
}

extension TabBarCoordinator: Coordinator {
    
    func setupHomeCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = HomeTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupPlaylistsCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = PlaylistsTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupBrowseCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = BrowseTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupSearchCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = SearchTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func setupSettingsCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = SettingsTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        childCoordinators.append(tabCoordinator)
    }
    
    func start() {
        setup()
        window.rootViewController = tabBarController
    }
    
    func setup() {
        tabBarController.setTabTitles(controllers: [childCoordinators[0].navigationController, childCoordinators[1].navigationController, childCoordinators[2].navigationController, childCoordinators[3].navigationController, childCoordinators[4].navigationController])
    }
}

