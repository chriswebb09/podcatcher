import UIKit

protocol TabControllerCoordinator: Coordinator {
    var window: UIWindow! { get set }
    var tabBarController: TabBarController { get set }
    var childCoordinators: [NavigationCoordinator] { get set }
}

extension TabControllerCoordinator {
    func addChild(coordinator: NavigationCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: NavigationCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

final class TabCoordinator: NavigationCoordinator {
    
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
        addChild(coordinator: tabCoordinator)
    }
    
    func setupBrowseCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = BrowseTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        addChild(coordinator: tabCoordinator)
    }
    
    func setupSearchCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = SearchTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        addChild(coordinator: tabCoordinator)
    }
    
    func setupSettingsCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = SettingsTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        tabCoordinator.dataSource = dataSource
        addChild(coordinator: tabCoordinator)
    }
    
    func start() {
        setup()
        window.rootViewController = tabBarController
    }
    
    func setup() {
        let controllers = [childCoordinators[0].navigationController,
                           childCoordinators[1].navigationController,
                           childCoordinators[2].navigationController,
                           childCoordinators[3].navigationController,
                           childCoordinators[4].navigationController]
        tabBarController.setTabTitles(controllers: controllers)
    }
}
