import UIKit
import CoreData

final class TabBarCoordinator: TabControllerCoordinator {
    
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
    
    func setupHomeCoordinator(navigationController: UINavigationController, persistentCoordinator: NSPersistentContainer) {
        let tabCoordinator = HomeTabCoordinator(navigationController: navigationController)
        tabCoordinator.persistentContainer = persistentCoordinator
        tabCoordinator.start()
        
        childCoordinators.append(tabCoordinator)
    }
    
    
    func setupSearchCoordinator(navigationController: UINavigationController) {
        let tabCoordinator = SearchTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        addChild(coordinator: tabCoordinator)
    }
    
    func setupSettingsCoordinator(navigationController: UINavigationController) {
        let tabCoordinator = SettingsTabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
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
                           childCoordinators[2].navigationController]
        tabBarController.setTabTitles(controllers: controllers)
    }
}

