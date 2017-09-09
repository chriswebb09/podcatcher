import UIKit
import CoreData

enum TransitionType {
    case zoom, pop
}

final class HomeTabCoordinator: NSObject, NavigationCoordinator, HomeCoordinator {
    
    private var thumbnailZoomTransitionAnimator: ImageTransitionAnimator?
    private var transitionThumbnail: UIImageView?
    
    weak var delegate: CoordinatorDelegate?
    
    internal var type: CoordinatorType = .tabbar
    
    internal var transitionType: TransitionType = .zoom
    
    private var store = SearchResultsDataStore()
    
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
        childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let homeViewController = navigationController.viewControllers[0] as! HomeViewController
        homeViewController.managedContext = feedStore.managedContext
        
        let controller: NSFetchedResultsController<Subscription> = {
            let fetchRequest: NSFetchRequest<Subscription> = Subscription.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: feedStore.managedContext, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try? controller.performFetch()
            }
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
                
                homeViewController.loading()
                
                store.pullFeed(for: feedUrlString) { response, arg  in
                    guard let episodes = response else { return }
                    
                    let resultsList = SearchResultListViewController(index: index)
                    
                    caster.episodes = episodes
                    resultsList.setDataItem(dataItem: caster)
                    resultsList.delegate = strongSelf
                    
                    DispatchQueue.main.async {
                        
                        resultsList.collectionView.reloadData()
                        homeViewController.finishLoading()
                        strongSelf.navigationController.delegate = self
                        strongSelf.transitionThumbnail = imageView
                        strongSelf.navigationController.pushViewController(resultsList, animated: true)
                    }
                }
            }
        }
    }
    
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage) {
        
        guard let feedUrlString = subscription.feedUrl else { return }
        
        let store = SearchResultsDataStore()
        var caster = CasterSearchResult()
        
        transitionType = .zoom
        
        caster.podcastArtUrlString = subscription.artworkImageUrl
        caster.podcastTitle = subscription.podcastTitle
        caster.feedUrl = subscription.feedUrl
        caster.podcastArtist = subscription.podcastArtist
        
        store.pullFeed(for: feedUrlString) { response, arg  in
            
            guard let episodes = response else { return }
            let resultsList = SearchResultListViewController(index: index)
            caster.episodes = episodes
            resultsList.setDataItem(dataItem: caster)
            resultsList.delegate = self
            
            DispatchQueue.main.async {
                
                resultsList.collectionView.reloadData()
                let homeViewController = self.navigationController.viewControllers[0] as! HomeViewController
                homeViewController.loading()
                
                self.navigationController.delegate = self
                self.transitionThumbnail?.image = image
                self.navigationController.pushViewController(resultsList, animated: true)
                
                resultsList.collectionView.reloadData()
            }
        }
    }
}

extension HomeTabCoordinator: PodcastListViewControllerDelegate {
    
    func saveFeed(item: CasterSearchResult, podcastImage: UIImage, episodesCount: Int) {
        
        let image = podcastImage
        
        guard let title = item.podcastTitle, let feedUrl = item.feedUrl, let artist = item.podcastArtist, let artUrl = item.podcastArtUrlString else { return }
        
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
        
        transitionType = .pop
        
        let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
        playerViewController.delegate = self
        
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.alpha = 0
        navigationController.delegate = self
        
        playerViewController.hideLoadingIndicator()
        
        DispatchQueue.main.async {
            self.navigationController.pushViewController(playerViewController, animated: true)
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
        transitionType = .zoom
        navigationController.popViewController(animated: false)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}

extension HomeTabCoordinator: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator()
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch transitionType {
            
        case .pop:
            return SimpleAnimationController()
        case .zoom:
            if operation == .push {
                guard let transitionThumbnail = transitionThumbnail, let transitionThumbnailSuperview = transitionThumbnail.superview else { return nil }
                thumbnailZoomTransitionAnimator = ImageTransitionAnimator()
                thumbnailZoomTransitionAnimator?.thumbnailFrame = transitionThumbnailSuperview.convert( transitionThumbnail.frame, to: toVC.view)
            }
            
            if operation == .pop {
                thumbnailZoomTransitionAnimator?.duration = 0.2
            }
            thumbnailZoomTransitionAnimator?.operation = operation
            
            return thumbnailZoomTransitionAnimator
        }
        
      
    }
}
