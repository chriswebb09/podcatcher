import UIKit
import CoreData

final class HomeTabCoordinator: NSObject, NavigationCoordinator, HomeCoordinator {
    
    private var thumbnailZoomTransitionAnimator: ImageTransitionAnimator?
    private var transitionThumbnail: UIImageView?
    var persistentContainer: NSPersistentContainer! 
    // let  persistentContainer = NSPersistentContainer(name: "Podcatch")
    weak var delegate: CoordinatorDelegate?
    //var podcastsData =  PodcastCoreData()
    internal var type: CoordinatorType = .tabbar
    
    internal var transitionType: TransitionType = .zoom
    
    private var store = SearchResultsDataStore()
    
    var feedStore = FeedCoreDataStack()
    
    var interactor = SearchResultsIteractor()
    
    private var childViewControllers: [UIViewController] = []
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
        navigationController.viewControllers.append(controller)
    }
    
    func start() {
        let backingVC = navigationController.viewControllers[0] as! HomeBackingViewController
        let homeViewController = backingVC.homeViewController
        homeViewController?.persistentContainer = persistentContainer
        backingVC.delegate = self
        backingVC.setupBrowse()
        
        homeViewController?.managedContext = feedStore.managedContext
        
        //        let backingVC = navigationController.viewControllers[0] as! HomeBackingViewController
        //        let homeViewController = backingVC.homeViewController
        //        backingVC.delegate = self
        //        backingVC.setupBrowse()
        
        
        let controller: NSFetchedResultsController<Podcaster> = {
            let fetchRequest: NSFetchRequest<Podcaster> = Podcaster.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try? controller.performFetch()
            }
            return controller
        }()
        
        
        //        let controller: NSFetchedResultsController<Subscription> = {
        //            let fetchRequest: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        //            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "feedUrl", ascending: true)]
        //            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: feedStore.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        //            do {
        //                try? controller.performFetch()
        //            }
        //            return controller
        //        }()
        
        homeViewController?.fetchedResultsController = controller
        homeViewController?.delegate = self
        homeViewController?.persistentContainer = persistentContainer
        homeViewController?.homeDataSource = CollectionViewDataSource(collectionView: (homeViewController?.collectionView)!, identifier: SubscriptionCell.reuseIdentifier, fetchedResultsController: controller, delegate: homeViewController!)
        controller.delegate = homeViewController?.homeDataSource
        homeViewController?.collectionView.dataSource = homeViewController?.homeDataSource
        //
        //        homeViewController?.fetchedResultsController = controller
        //        homeViewController?.delegate = self
        //        homeViewController?.persistentContainer = persistentContainer
        //       // homeViewController?.fetchedResultsContr
        //     //   homeViewController?.homeDataSource = CollectionViewDataSource(collectionView: (homeViewController?.collectionView)!, identifier: SubscribedPodcastCell.reuseIdentifier, fetchedResultsController: controller, delegate: homeViewController!)
        //       // controller.delegate = homeViewController?.homeDataSource
        //        homeViewController?.collectionView.dataSource = homeViewController?.homeDataSource
    }
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            self.setHomeNav()
        } else if segmentIndex == 1 {
            print("case 1")
        } else if segmentIndex == 2 {
            print("case 2")
        }
    }
    
    func setHomeNav() {
        //        let nav = navigationController.childViewControllers[0] as! UINavigationController
        //       // let backingVC = nav.viewControllers[0] as! BackingViewController
        //        navigationItem.title = "Podcasts"
        //        backingVC.navigationItem.rightBarButtonItem = backingVC.homeViewController.rightButtonItem
        //        backingVC.navigationItem.leftBarButtonItem = backingVC.homeViewController.leftButtonItem
    }
}

extension HomeTabCoordinator: HomeViewControllerDelegate {
    
    func updateNavigationItems() {
        let nav = navigationController.childViewControllers[0] as! UINavigationController
        //        let backingVC = nav.viewControllers[0] as! BackingViewController
        //        DispatchQueue.main.async {
        //            backingVC.navigationItem.leftBarButtonItem = backingVC.homeViewController.leftButtonItem
        //        }
    }
    
    func selectedItem(at: Int, podcast: Podcaster, imageView: UIImageView) {
        let store = SearchResultsDataStore()
        let feedPodcast = Podcast()
        self.transitionThumbnail = imageView
        //        self.selectedImageView = imageView
        //        self.selectedFrame = imageView.frame
        feedPodcast.artistId = podcast.artistId!
        feedPodcast.podcastTitle = podcast.podcastTitle!
        feedPodcast.category = podcast.category!
        feedPodcast.id = podcast.podcastId!
        feedPodcast.feedUrl = podcast.feedUrl!
        feedPodcast.itunesUrlString = podcast.itunesUrl!
        feedPodcast.tags = []
        feedPodcast.podcastArtist = podcast.podcastArtist!
        feedPodcast.podcastArtUrlString = podcast.podcastArtworkUrl!
        let imageData = podcast.podcastArtworkImage! as Data
        let image = UIImage(data: imageData)
        //let nav = navigationController.childViewControllers[0] as! UINavigationController
        // let backingVC = nav.viewControllers[0] as! BackingViewController
        // backingVC.loadingPop.show(controller: backingVC)
        let resultsList = PodcastListViewController(index: at)
        //SearchResultListViewController(index: at)
        resultsList.persistentContainer = self.persistentContainer
        resultsList.currentParent = .home
        resultsList.index = 0
        resultsList.delegate = self
        resultsList.miniPlayer = MiniPlayerViewController()
        //backingVC.miniPlayerViewController
        
        store.pullFeed(for: feedPodcast.feedUrl) {  response, error  in
            
            if error != nil {
                print(error?.localizedDescription ?? "unable to get specific error")
                //backingVC.loadingPop.hideLoadingView(controller: backingVC)
                return
            } else {
                //                DispatchQueue.main.async {
                //                    backingVC.loadingPop.hideLoadingView(controller: backingVC)
                //                }
            }
            guard let episodes = response else { return }
            feedPodcast.episodes = episodes
            resultsList.setDataItem(dataItem: feedPodcast)
            DispatchQueue.main.async {
                // backingVC.loadingPop.hideLoadingView(controller: backingVC)
                //resultsList.title = feedPodcast.podcastArtist
                if let url = URL(string: feedPodcast.podcastArtUrlString) {
                    resultsList.topView.setTopImage(from: url)
                    //resultsList.topView.podcastImageView.image = image
                }
                //backingVC.loadingPop.hideLoadingView(controller: backingVC)
                //self.navigationController.title = podcast.podcastArtist
                self.navigationController.delegate = self
                self.navigationController.pushViewController(resultsList, animated: true)
            }
        }
    }
    //    func selectedItem(at: Int, podcast: Podcaster, imageView: UIImageView) {
    //        let store = SearchResultsDataStore()
    //        print(podcast)
    //        let feedPodcast = Podcast()
    ////        self.selectedImageView = imageView
    ////        self.selectedFrame = imageView.frame
    //        feedPodcast.artistId = podcast.artistId!
    //        feedPodcast.podcastTitle = podcast.podcastTitle!
    //        feedPodcast.category = podcast.category!
    //        feedPodcast.id = podcast.podcastId!
    //        feedPodcast.feedUrl = podcast.feedUrl!
    //        feedPodcast.itunesUrlString = podcast.itunesUrl!
    //        feedPodcast.tags = []
    //        feedPodcast.podcastArtist = podcast.podcastArtist!
    //        feedPodcast.podcastArtUrlString = podcast.podcastArtworkUrl!
    //
    //        let imageData = podcast.podcastArtworkImage! as Data
    //
    //        let image = UIImage(data: imageData)
    //       // let nav = navigationController.childViewControllers[0] as! UINavigationController
    //        ///let backingVC = nav.viewControllers[0] as! BackingViewController
    //        //backingVC.loadingPop.show(controller: backingVC)
    //
    //        let resultsList = PodcastListViewController(index: at)
    //            //SearchResultListViewController(index: at)
    //        resultsList.persistentContainer = self.persistentContainer
    //        resultsList.currentParent = .home
    //        resultsList.index = 0
    //        resultsList.delegate = self
    //      //  resultsList.miniPlayer = backingVC.miniPlayerViewController
    //
    //        store.pullFeed(for: feedPodcast.feedUrl) {  response, error  in
    //
    //            if error != nil {
    //                print(error?.localizedDescription ?? "unable to get specific error")
    //                //backingVC.loadingPop.hideLoadingView(controller: backingVC)
    //                return
    //            } else {
    ////                DispatchQueue.main.async {
    ////                    backingVC.loadingPop.hideLoadingView(controller: backingVC)
    ////                }
    //            }
    //
    //            guard let episodes = response else { return }
    //
    //            feedPodcast.episodes = episodes
    //            resultsList.setDataItem(dataItem: feedPodcast)
    //            DispatchQueue.main.async {
    //               // backingVC.loadingPop.hideLoadingView(controller: backingVC)
    //                resultsList.title = feedPodcast.podcastArtist
    //                if URL(string: feedPodcast.podcastArtUrlString) != nil {
    //                    resultsList.topView.setTopImage(image: image!)
    //                    //resultsList.topView.podcastImageView.image = image
    //                }
    //              //  backingVC.loadingPop.hideLoadingView(controller: backingVC)
    //                self.navigationController.title = podcast.podcastArtist
    //                self.navigationController.delegate = self
    //                self.transitionThumbnail = imageView
    //                self.navigationController.pushViewController(resultsList, animated: true)
    //            }
    //        }
    //    }
    
    func updateNavigation(for isNil: Bool) {
        if isNil {
            DispatchQueue.main.async {
                self.setHomeNav()
            }
        }
    }
    //    func selectedItem(at: Int, podcast: Podcaster, imageView: UIImageView) {
    //
    //    }
    //
    //    func updateNavigation(for isNil: Bool) {
    //
    //    }
    //
    //    func updateNavigationItems() {
    //
    //    }
    //
    //
    
}

//extension HomeTabCoordinator: PodcastListViewControllerDelegate {
//
//}

//    func didSelect(at index: Int, with subscription: Podcast, image: UIImage, imageView: UIImageView) {
//
//        let store = SearchResultsDataStore()
//        var caster = PodcastItem()
//
//        guard let feedUrlString = subscription.feedUrl else { return }
//
//        caster.podcastArtUrlString = subscription.artworkImageUrl
//        caster.podcastTitle = subscription.podcastTitle
//        caster.feedUrl = subscription.feedUrl
//        caster.podcastArtist = subscription.podcastArtist
//
//        concurrent.async { [weak self] in
//
//            if let strongSelf = self {
//                let backingVC = strongSelf.navigationController.viewControllers[0] as! HomeBackingViewController
//                //    let homeViewController = strongSelf.navigationController.viewControllers[0] as! HomeViewController
//                let homeViewController = backingVC.homeViewController
//                homeViewController?.loading()
//
//                store.pullFeed(for: feedUrlString) { response, arg  in
//                    guard let episodes = response else { return }
//
//                    let resultsList = SearchResultListViewController(index: index)
//
//                    caster.episodes = episodes
//                    resultsList.setDataItem(dataItem: caster)
//                    resultsList.delegate = strongSelf
//
//                    DispatchQueue.main.async {
//
//                        resultsList.collectionView.reloadData()
//                        homeViewController?.finishLoading()
//                        strongSelf.navigationController.delegate = self
//                        strongSelf.transitionThumbnail = imageView
//                        strongSelf.navigationController.pushViewController(resultsList, animated: true)
//                    }
//                }
//            }
//        }
//    }

//    func didSelect(at index: Int, with subscription: Subscription, image: UIImage) {
//
//        guard let feedUrlString = subscription.feedUrl else { return }
//
//        let store = SearchResultsDataStore()
//        var caster = CasterSearchResult()
//
//        transitionType = .zoom
//
//        caster.podcastArtUrlString = subscription.artworkImageUrl
//        caster.podcastTitle = subscription.podcastTitle
//        caster.feedUrl = subscription.feedUrl
//        caster.podcastArtist = subscription.podcastArtist
//
//        store.pullFeed(for: feedUrlString) { response, arg  in
//
//            guard let episodes = response else { return }
//            let resultsList = SearchResultListViewController(index: index)
//            caster.episodes = episodes
//            resultsList.setDataItem(dataItem: caster)
//            resultsList.delegate = self
//
//            DispatchQueue.main.async {
//
//                resultsList.collectionView.reloadData()
//                let homeViewController = self.navigationController.viewControllers[0] as! HomeViewController
//                homeViewController.loading()
//
//                self.navigationController.delegate = self
//                self.transitionThumbnail?.image = image
//                self.navigationController.pushViewController(resultsList, animated: true)
//
//                resultsList.collectionView.reloadData()
//            }
//        }
//    }
//}

extension HomeTabCoordinator: HomeBackingViewControllerDelegate {
    func updatePodcast(with id: String) {
        delegate?.updatePodcast(with: id)
    }
}

extension HomeTabCoordinator: PodcastListViewControllerDelegate {
    func didSelectPodcastAt(at index: Int, podcast: PodcastItem, with episodes: [Episode]) {
        
    }
    
    
    func addToPlaylist(episde: Episodes) {
        let nav = navigationController.childViewControllers[0] as! UINavigationController
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let playlists = appDelegate.dataStore.playlistDatabase.fetchPlaylists()
            guard let resultsList = nav.viewControllers.last as? PodcastListViewController else { fatalError() }
             resultsList.buildModal(for: playlists, for: episde)
        }
    }
    
    func goToDescription() {
        print("description")
    }
    
    func saveFeed(item: Podcast, podcastImage: UIImage, episodesCount: Int) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.dataStore.subscriptionDatabase.saveSubscription(manageContext: persistentContainer.viewContext, item: item, podcastImage: podcastImage)
        }
    }
    
    @objc func hideLoadingPop() {
        let nav = navigationController.childViewControllers[0] as! UINavigationController
        //        let backingVC = nav.viewControllers[0] as! BackingViewController
        //        backingVC.loadingPop.hideLoadingView(controller: backingVC)
    }
    
}
//
//    func saveFeed(item: CasterSearchResult, podcastImage: UIImage, episodesCount: Int) {
//        
//        let image = podcastImage
//        
//        guard let title = item.podcastTitle, let feedUrl = item.feedUrl, let artist = item.podcastArtist, let artUrl = item.podcastArtUrlString else { return }
//        
//        feedStore.save(feedUrl: feedUrl,
//                       podcastTitle: title,
//                       episodeCount: episodesCount,
//                       lastUpdate: NSDate(),
//                       image: image,
//                       uid: "none",
//                       artworkUrlString: artUrl,
//                       artistName: artist)
//        
//        var subscriptions = UserDefaults.loadSubscriptions()
//        subscriptions.append(feedUrl)
//        
//        UserDefaults.saveSubscriptions(subscriptions: subscriptions)
//    }
//    
//    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episode]) {
//        
//        var playerPodcast = podcast
//        playerPodcast.episodes = episodes
//        playerPodcast.index = index
//        
//        transitionType = .pop
//        
//        let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
//        playerViewController.delegate = self
//        
//        navigationController.navigationBar.isTranslucent = true
//        navigationController.navigationBar.alpha = 0
//        navigationController.delegate = self
//        
//        playerViewController.hideLoadingIndicator()
//        
//        DispatchQueue.main.async {
//            self.navigationController.pushViewController(playerViewController, animated: true)
//        }
//    }
//}


extension HomeTabCoordinator: PlayerViewControllerDelegate {
    func saveItemCoreData(item: PodcastItem, index: Int, image: UIImage) {
        //        let imageData = UIImagePNGRepresentation(image)
        //        guard let title = item.podcastTitle else { return }
        //        if (item.artistId) != nil {
        //            podcastsData.save(title: item.episodes[index].title, audioUrl: item.episodes[index].audioUrlSting, podcasterName: item.podcastArtist!, podcastId: title, episodeId: item.episodes[index].podcastTitle, podcastImage: imageData! as NSData)
        //        } else {
        //            podcastsData.save(title: item.episodes[index].title, audioUrl: item.episodes[index].audioUrlSting, podcasterName: item.podcastArtist!, podcastId: title, episodeId: item.episodes[index].podcastTitle, podcastImage: imageData! as NSData)
        //        }
        //
        //  PodcastCoreData
    }
    
    
    
    func addItemToPlaylist(item: PodcastItem, index: Int) {
        
        let controller = navigationController.viewControllers.last
        controller?.tabBarController?.selectedIndex = 1
        
        guard let tab =  controller?.tabBarController else { return }
        let nav = tab.viewControllers?[1] as! UINavigationController
        let playlists = nav.viewControllers[0] as! PlaylistsViewController
        
//        playlists.reference = .addPodcast
//        playlists.index = index
//        playlists.item = item
        
        controller?.tabBarController?.tabBar.alpha = 1
        navigationController.navigationBar.alpha = 1
        delegate?.podcastItem(toAdd: item, with: index)
    }
    
    func navigateBack(tapped: Bool) {
        transitionType = .zoom
        navigationController.delegate = self
        let vc = navigationController.viewControllers[navigationController.viewControllers.count - 2] as! PodcastListViewController
        vc.navPop = true
        vc.topView.frame = PodcastListConstants.topFrame
        
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
            return nil
            //ImageTransitionAnimator()
        //SimpleAnimationController()
        case .zoom:
            if operation == .push {
                guard let transitionThumbnail = transitionThumbnail, let transitionThumbnailSuperview = transitionThumbnail.superview else { return nil }
                thumbnailZoomTransitionAnimator = ImageTransitionAnimator()
                thumbnailZoomTransitionAnimator?.thumbnailFrame = transitionThumbnailSuperview.convert(transitionThumbnail.frame, to: toVC.view)
            }
            
            if operation == .pop {
                guard let navHeight = fromVC.navigationController?.navigationBar.frame.height else { return nil }
                guard let tabHeight = fromVC.tabBarController?.tabBar.frame.height else { return nil }
                toVC.view.frame = CGRect(x: fromVC.view.frame.minX, y: fromVC.view.frame.maxY + (navHeight + tabHeight), width: fromVC.view.frame.width, height: UIScreen.main.bounds.height)
                toVC.viewDidLoad()
                thumbnailZoomTransitionAnimator?.duration = 0.1
            }
            
            thumbnailZoomTransitionAnimator?.operation = operation
            return thumbnailZoomTransitionAnimator
        }
    }
}

