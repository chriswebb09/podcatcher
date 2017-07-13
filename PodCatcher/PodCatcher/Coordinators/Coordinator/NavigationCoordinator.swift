import UIKit

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}

protocol PlaylistTabDelegate: CoordinatorDelegate {
    func updatePodcast(with playlistId: String)
}

class NavCoordinator: NavigationCoordinator {
    
    var type: CoordinatorType
    
    weak var delegate: CoordinatorDelegate?
    
    var childViewControllers: [UIViewController] = []
    var window: UIWindow!
    var navigationController: UINavigationController {
        didSet {
            childViewControllers = navigationController.viewControllers
        }
    }
    
    init(navigationController: UINavigationController = UINavigationController(), type: CoordinatorType) {
        self.navigationController = navigationController
        self.type = type
    }
    
    convenience init(navigationController: UINavigationController, window: UIWindow, type: CoordinatorType) {
        self.init(navigationController: navigationController, type: type)
        self.window = window
    }
    
    func start() {
        // Fix
    }
}

