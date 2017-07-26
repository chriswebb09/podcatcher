import UIKit

final class HomeTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var fetcher = SearchResultsFetcher()
    
    let mainStore = MainStore()
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
        store.pullFeed(for: feedUrlString) { response in
            guard let episodes = response.0 else { return }
            DispatchQueue.main.async {
                resultsList.episodes = episodes
                resultsList.collectionView.reloadData()
                self.navigationController.viewControllers.append(resultsList)
            }
        }
    }
    
    func logout(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
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
                store.pullFeed(for: feedUrlString) { response in
                    guard let episodes = response.0 else { return }
                    resultsList.item.episodes = episodes
                    resultsList.episodes = episodes
                    DispatchQueue.main.async {
                        resultsList.collectionView.reloadData()
                        strongSelf.navigationController.viewControllers.append(resultsList)
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
                let playerViewController = PlayerViewController(index: index,
                                                                caster: playerPodcast,
                                                                image: image, player: AudioFilePlayer.shared)
                playerViewController.delegate = strongSelf
                DispatchQueue.main.async {
                    strongSelf.navigationController.navigationBar.isTranslucent = true
                    strongSelf.navigationController.navigationBar.alpha = 0
                    strongSelf.navigationController.viewControllers.append(playerViewController)
                }
            }
        }
    }
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        var playerPodcast = podcast
        playerPodcast.episodes = episodes
        print("at index: Int, podcast: CasterSearchResult, with episodes: [Episodes])")
        playerPodcast.index = index
        let concurrent = DispatchQueue(label: "concurrentBackground",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: nil)
        concurrent.async { [weak self] in
            if let strongSelf = self {
                let playerViewController = PlayerViewController(index: index,
                                                                caster: playerPodcast,
                                                                image: nil, player: AudioFilePlayer.shared)
                playerViewController.delegate = strongSelf
                DispatchQueue.main.async {
                    strongSelf.navigationController.navigationBar.isTranslucent = true
                    strongSelf.navigationController.navigationBar.alpha = 0
                    strongSelf.navigationController.viewControllers.append(playerViewController)
                }
            }
        }
    }
}

extension HomeTabCoordinator: PlayerViewControllerDelegate {
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let newItem = PodcastPlaylistItem(context: managedContext)
        newItem.audioUrl = item.episodes[index].audioUrlString
        newItem.artworkUrl = item.podcastArtUrlString
        newItem.artistId = item.id
        newItem.episodeTitle = item.episodes[index].title
        newItem.episodeDescription = item.episodes[index].description
        newItem.stringDate = item.episodes[index].date
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
    
    func skipButton(tapped: Bool) {
        print("SkipButton tapped \(tapped)")
    }
    
    func pauseButton(tapped: Bool) {
        print("PauseButton tapped \(tapped)")
    }
    
    func playButton(tapped: Bool) {
        print("PlayButton tapped \(tapped)")
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}
