import UIKit
import CoreData

final class PlaylistsTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    var testItems = [String]()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let playlistsViewController = navigationController.viewControllers[0] as! PlaylistsViewController
        playlistsViewController.delegate = self
    }
    
    func setup() {
        let playlistsViewController = navigationController.viewControllers[0] as! PlaylistsViewController
        playlistsViewController.delegate = self
        playlistsViewController.mediaDataSource = dataSource
    }
}

extension PlaylistsTabCoordinator: PlaylistsViewControllerDelegate {
    
    func didAssignPlaylist(with id: String) {
        delegate?.updatePodcast(with: id)
        let controller = navigationController.viewControllers.last as! PlaylistsViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 2
    }
}
