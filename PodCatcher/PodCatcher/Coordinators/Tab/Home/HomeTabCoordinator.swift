import UIKit

final class HomeTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var fetcher = SearchResultsFetcher()
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
        let homeViewController = navigationController.viewControllers[0] as! HomeViewController
        homeViewController.delegate = self
    }
}

extension HomeTabCoordinator: HomeViewControllerDelegate {
    
    func didSelect(at index: Int, with cast: PodcastSearchResult, image: UIImage) {
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.item = cast as! CasterSearchResult
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        let store = SearchResultsDataStore()
        
        store.pullFeed(for: feedUrlString) { response, arg  in
            guard let episodes = response else { return }
            DispatchQueue.main.async {
                resultsList.episodes = episodes
                resultsList.collectionView.reloadData()
                self.navigationController.pushViewController(resultsList, animated: false)
            }
        }
    }
    
    func didSelect(at index: Int, with subscription: Subscription, image: UIImage) {
        
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        
        guard let feedUrlString = subscription.feedUrl else { return }
        if let imageData =  subscription.artworkImage as Data? {
            resultsList.topView.podcastImageView.image = UIImage(data: imageData)
        }
        
        let store = SearchResultsDataStore()
        var caster = CasterSearchResult()
        caster.podcastArtUrlString = subscription.artworkImageUrl
        caster.podcastTitle = subscription.podcastTitle
        caster.feedUrl = subscription.feedUrl
        caster.podcastArtist = subscription.podcastArtist
        resultsList.item = caster
        let concurrent = DispatchQueue(label: "concurrentBackground",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: nil)
        concurrent.async { [weak self] in
            if let strongSelf = self {
                store.pullFeed(for: feedUrlString) { response, arg  in
                    guard let episodes = response else { return }
                    resultsList.item.episodes = episodes
                    resultsList.episodes = episodes
                    DispatchQueue.main.async {
                        resultsList.collectionView.reloadData()
                        strongSelf.navigationController.pushViewController(resultsList, animated: false)
                    }
                }
            }
        }
    }
}

extension HomeTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelect(at index: Int, podcast: CasterSearchResult, image: UIImage) {
        
        var playerPodcast = podcast
        playerPodcast.episodes =  podcast.episodes
        playerPodcast.index = index
        
        let concurrent = DispatchQueue(label: "concurrentBackground",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: nil)
        concurrent.async { [weak self] in
            if let strongSelf = self {
                let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: image)
                playerViewController.delegate = strongSelf
                DispatchQueue.main.async {
                    strongSelf.navigationController.navigationBar.isTranslucent = true
                    strongSelf.navigationController.navigationBar.alpha = 0
                    strongSelf.navigationController.pushViewController(playerViewController, animated: false)
                }
            }
        }
    }
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        
        var playerPodcast = podcast
        playerPodcast.episodes = episodes
        playerPodcast.index = index
        
        let concurrent = DispatchQueue(label: "concurrentBackground",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: nil)
        
        concurrent.async { [weak self] in
            if let strongSelf = self {
                let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
                playerViewController.delegate = strongSelf
                DispatchQueue.main.async {
                    strongSelf.navigationController.navigationBar.isTranslucent = true
                    strongSelf.navigationController.navigationBar.alpha = 0
                    strongSelf.navigationController.pushViewController(playerViewController, animated: false)
                }
            }
        }
    }
}

extension HomeTabCoordinator: PlayerViewControllerDelegate {
    
    func playPaused(tapped: Bool) {
        
    }
    
    func backButton(tapped: String) {
        print(tapped)
    }
    
    func playButton(tapped: String) {
        print(tapped)
    }
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        //PodcastPlaylistItem.addItem(item: item, for: index)
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
    
    func skipButton(tapped: String) {
        print(tapped)
    }
    
    func pauseButton(tapped: String) {
        print(tapped)
    }
    
    func playButton(tapped: Bool) {
        print(tapped)
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}
