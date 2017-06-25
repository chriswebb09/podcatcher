import UIKit

class FavoritesTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let favoritesController = navigationController.viewControllers[0] as! FavoritePodcastsViewController
        favoritesController.delegate = self
    }
}

extension FavoritesTabCoordinator: MediaControllerDelegate {
    
    func logout(tapped: Bool) {
        
    }
    
    func didSelect(at index: Int) {
        
    }
}
