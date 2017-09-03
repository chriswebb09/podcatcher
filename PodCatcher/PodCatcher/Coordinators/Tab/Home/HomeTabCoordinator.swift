import UIKit
import CoreData

final class HomeTabCoordinator: NSObject, NavigationCoordinator, HomeCoordinator {
    
    var thumbnailZoomTransitionAnimator: ThumbnailZoomTransitionAnimator?
    var transitionThumbnail: UIImageView?
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var feedStore = FeedCoreDataStack()
    var interactor = SearchResultsIteractor()
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    let concurrent = DispatchQueue(label: "concurrentBackground",
                                   qos: .background,
                                   attributes: .concurrent,
                                   autoreleaseFrequency: .inherit,
                                   target: nil)
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let homeViewController = navigationController.viewControllers[0] as! HomeViewController
        homeViewController.managedContext = feedStore.managedContext
        var controller: NSFetchedResultsController<Subscription> = {
            let fetchRequest: NSFetchRequest<Subscription> = Subscription.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
            var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: feedStore.managedContext, sectionNameKeyPath: nil, cacheName: nil)
            try! controller.performFetch()
            return controller
        }()
        homeViewController.fetchedResultsController = controller
        homeViewController.delegate = self
    }
}

extension HomeTabCoordinator: HomeViewControllerDelegate {
    
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage, imageView: UIImageView) {
        let store = SearchResultsDataStore()
        var caster = CasterSearchResult()
        
        guard let feedUrlString = subscription.feedUrl else { return }
        caster.podcastArtUrlString = subscription.artworkImageUrl
        caster.podcastTitle = subscription.podcastTitle
        caster.feedUrl = subscription.feedUrl
        caster.podcastArtist = subscription.podcastArtist
        
        concurrent.async { [weak self] in
            if let strongSelf = self {
                let homeViewController = strongSelf.navigationController.viewControllers[0] as! HomeViewController
                DispatchQueue.main.async {
                    homeViewController.showLoadingView(loadingPop: homeViewController.loadingPop)
                }
                store.pullFeed(for: feedUrlString) { response, arg  in
                    guard let episodes = response else { return }
                    let resultsList = SearchResultListViewController(index: index)
                    
                    DispatchQueue.main.async {
                        resultsList.item = caster
                        resultsList.item.episodes = episodes
                        resultsList.episodes = episodes
                        resultsList.delegate = strongSelf
                        resultsList.dataSource = strongSelf.dataSource
                        resultsList.collectionView.reloadData()
                        
                        homeViewController.hideLoadingView(loadingPop: homeViewController.loadingPop)
                        strongSelf.navigationController.delegate = self
                        strongSelf.transitionThumbnail = imageView
                        strongSelf.navigationController.pushViewController(resultsList, animated: true)
                    }
                }
            }
        }
    }
    
    
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage) {
        let store = SearchResultsDataStore()
        var caster = CasterSearchResult()
        
        guard let feedUrlString = subscription.feedUrl else { return }
        caster.podcastArtUrlString = subscription.artworkImageUrl
        caster.podcastTitle = subscription.podcastTitle
        caster.feedUrl = subscription.feedUrl
        caster.podcastArtist = subscription.podcastArtist
        
        concurrent.async { [weak self] in
            if let strongSelf = self {
                store.pullFeed(for: feedUrlString) { response, arg  in
                    guard let episodes = response else { return }
                    DispatchQueue.main.async {
                        let resultsList = SearchResultListViewController(index: index)
                        resultsList.item = caster
                        resultsList.item.episodes = episodes
                        resultsList.episodes = episodes
                        resultsList.delegate = strongSelf
                        resultsList.dataSource = strongSelf.dataSource
                        resultsList.collectionView.reloadData()
                        let homeViewController = strongSelf.navigationController.viewControllers[0] as! HomeViewController
                        homeViewController.hideLoadingView(loadingPop: homeViewController.loadingPop)
                        strongSelf.navigationController.delegate = self
                        self?.transitionThumbnail?.image = image
                        var thumbnailZoomTransitionAnimator: ThumbnailZoomTransitionAnimator?
                        strongSelf.navigationController.pushViewController(resultsList, animated: true)
                        
                        resultsList.collectionView.reloadData()
                        strongSelf.navigationController.navigationBar.backItem?.title = ""
                        strongSelf.navigationController.navigationItem.backBarButtonItem?.title = ""
                        resultsList.navigationItem.backBarButtonItem?.title = ""
                        
                    }
                }
            }
        }
    }
}

extension HomeTabCoordinator: PodcastListViewControllerDelegate {
    
    func saveFeed(item: CasterSearchResult, podcastImage: UIImage, episodesCount: Int) {
        
        guard let title = item.podcastTitle else { return }
        let image = podcastImage
        guard let feedUrl = item.feedUrl else { return }
        guard let artist = item.podcastArtist else { return }
        guard let artUrl = item.podcastArtUrlString else { return }
        feedStore.save(feedUrl: feedUrl,
                       podcastTitle: title,
                       episodeCount: episodesCount,
                       lastUpdate: NSDate(),
                       image: image,
                       uid: "none",
                       artworkUrlString: artUrl,
                       artistName: artist)
        var subscriptions = UserDefaults.loadSubscriptions()
        subscriptions.append(feedUrl)
        UserDefaults.saveSubscriptions(subscriptions: subscriptions)
    }
    
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        
        var playerPodcast = podcast
        playerPodcast.episodes = episodes
        playerPodcast.index = index
        
        concurrent.async { [weak self] in
            if let strongSelf = self {
                let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
                playerViewController.delegate = strongSelf
                DispatchQueue.main.async {
                    strongSelf.navigationController.navigationBar.isTranslucent = true
                    strongSelf.navigationController.navigationBar.alpha = 0
                    strongSelf.navigationController.delegate = self
                    
                    strongSelf.navigationController.pushViewController(playerViewController, animated: false)
                }
            }
        }
    }
}

extension HomeTabCoordinator: PlayerViewControllerDelegate {
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        let controller = navigationController.viewControllers.last
        controller?.tabBarController?.selectedIndex = 1
        guard let tab =  controller?.tabBarController else { return }
        let nav = tab.viewControllers?[1] as! UINavigationController
        let playlists = nav.viewControllers[0] as! PlaylistsViewController
        playlists.reference = .addPodcast
        playlists.index = index
        playlists.item = item
        controller?.tabBarController?.tabBar.alpha = 1
        navigationController.navigationBar.alpha = 1
        delegate?.podcastItem(toAdd: item, with: index)
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.popViewController(animated: false)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}

extension HomeTabCoordinator: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ThumbnailZoomTransitionAnimator()
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            guard let transitionThumbnail = transitionThumbnail, let transitionThumbnailSuperview = transitionThumbnail.superview else { return nil }
            thumbnailZoomTransitionAnimator = ThumbnailZoomTransitionAnimator()
            thumbnailZoomTransitionAnimator?.thumbnailFrame = transitionThumbnailSuperview.convert(transitionThumbnail.frame, to: nil)
        }
        
        if operation == .pop {
            thumbnailZoomTransitionAnimator?.duration = 0.2
        }
        thumbnailZoomTransitionAnimator?.operation = operation
        return thumbnailZoomTransitionAnimator
    }
}
