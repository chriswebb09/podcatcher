import UIKit

enum CoordinatorType {
    case app, tabbar
}

protocol CoordinatorDelegate: class {
    func transitionCoordinator(type: CoordinatorType, dataSource: BaseMediaControllerDataSource?)
    func updatePodcast(with playlistId: String)
    func podcastItem(toAdd: CasterSearchResult, with index: Int)
    func addItemToPlaylist(podcastPlaylist: PodcastPlaylist)
}

protocol Coordinator: class {
    weak var delegate: CoordinatorDelegate? { get set }
    var type: CoordinatorType { get set }
    func start()
}

protocol ApplicationCoordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var appCoordinator: Coordinator { get set }
    var window: UIWindow { get set }
    func start()
}

extension ApplicationCoordinator {
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}

protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

typealias RootViewCoordinator = Coordinator & RootViewControllerProvider

