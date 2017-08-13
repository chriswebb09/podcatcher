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

protocol ApplicationCoordinator {
    var appCoordinator: Coordinator { get set }
    var window: UIWindow { get set }
    func start()
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}

import UIKit

// MARK: - Root View Controller Provider

protocol RootViewControllerProvider: class {
    
    var rootViewController: UIViewController { get }
    
}

// MARK: - Root View Coordinator

typealias RootViewCoordinator = Coordinator & RootViewControllerProvider

