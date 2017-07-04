import UIKit

protocol TabControllerCoordinator: Coordinator {
    var window: UIWindow! { get set }
    var tabBarController: TabBarController { get set }
    var childCoordinators: [NavigationCoordinator] { get set }
}
