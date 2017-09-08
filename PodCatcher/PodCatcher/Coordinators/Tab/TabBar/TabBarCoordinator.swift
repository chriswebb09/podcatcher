import UIKit

final class TabBarCoordinator: TabControllerCoordinator, RootViewCoordinator {
    
    var rootViewController: UIViewController {
        return tabBarController
    }
    
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
    
    func setupHomeCoordinator(navigationController: UINavigationController, dataSource: BaseMediaControllerDataSource) {
        let tabCoordinator = HomeTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
       
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
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
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
