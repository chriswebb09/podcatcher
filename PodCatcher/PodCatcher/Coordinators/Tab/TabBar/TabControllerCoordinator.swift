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
