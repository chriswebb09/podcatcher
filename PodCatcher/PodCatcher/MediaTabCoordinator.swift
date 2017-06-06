import UIKit

class MediaTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    
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
        let mediaController = navigationController.viewControllers[0] as! MediaCollectionViewController
        mediaController.delegate = self
    }
}

extension MediaTabCoordinator: MediaControllerDelegate {
    
    func didSelectCaster(at index: Int, with playlist: Caster) {
        let podcastList = PodcastListViewController()
        podcastList.caster = playlist
        podcastList.delegate = self
        navigationController.viewControllers.append(podcastList)
        print("selected")
    }
}

extension MediaTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectTrackAt(at index: Int, with playlist: Caster) {
        let playerView = PlayerView()
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: playlist)
        navigationController.viewControllers.append(playerViewController)
        print("selected")
    }
}
