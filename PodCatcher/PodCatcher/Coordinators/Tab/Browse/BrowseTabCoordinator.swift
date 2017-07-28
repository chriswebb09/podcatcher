
import UIKit

final class BrowseTabCoordinator: NavigationCoordinator {
    
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
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        browseViewController.delegate = self
    }
    
    func setupBrowse() {
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        getTopItems { newItems in
            
            let concurrentQueue = DispatchQueue(label: "concurrent",
                                                qos: .background,
                                                attributes: .concurrent,
                                                autoreleaseFrequency: .inherit,
                                                target: nil)
            
            concurrentQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                var results = [CasterSearchResult]()
                
                for item in newItems {
                    
                    strongSelf.fetcher.setLookup(term: item.id)
                    strongSelf.fetcher.searchForTracksFromLookup { result in
                        guard let resultItem = result.0 else { return }
                        
                        resultItem.forEach { resultingData in
                            guard let resultingData = resultingData else { return }
                            
                            if let caster = CasterSearchResult(json: resultingData) {
                                results.append(caster)
                                DispatchQueue.main.async {
                                    browseViewController.collectionView.reloadData()
                                }
                            }
                        }
                        browseViewController.dataSource.items = results
                        guard let urlString = browseViewController.dataSource.items[0].podcastArtUrlString else { return }
                        guard let imageUrl = URL(string: urlString) else { return }
                        browseViewController.topView.podcastImageView.downloadImage(url: imageUrl)
                    }
                }
            }
        }
    }
    
    func getTopItems(completion: @escaping ([TopItem]) -> Void) {
        let concurrentQueue = DispatchQueue(label: "concurrent",
                                            qos: .background,
                                            attributes: .concurrent,
                                            autoreleaseFrequency: .inherit,
                                            target: nil)
        concurrentQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.store.pullFeedTopPodcasts { data, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
}

extension BrowseTabCoordinator: BrowseViewControllerDelegate {
    
    func didSelect(at index: Int, with caster: PodcastSearchResult) {
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.item = caster as! CasterSearchResult
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        let store = SearchResultsDataStore()
        let concurrent = DispatchQueue(label: "concurrentBackground",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: nil)
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            store.pullFeed(for: feedUrlString) { response in
                guard let episodes = response.0 else { return }
                resultsList.episodes = episodes
                DispatchQueue.main.async {
                    resultsList.collectionView.reloadData()
                    strongSelf.navigationController.viewControllers.append(resultsList)
                    browseViewController.collectionView.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension BrowseTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelect(at index: Int, podcast: CasterSearchResult) {
        var playerPodcast = podcast
        playerPodcast.index = index
        let playerViewController = PlayerViewController(index: index,
                                                        caster: playerPodcast,
                                                        image: nil, player: AudioFilePlayer.shared)
        playerViewController.delegate = self
        navigationController.viewControllers.append(playerViewController)
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
            guard let strongSelf = self else { return }
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

extension BrowseTabCoordinator: PlayerViewControllerDelegate {
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        PodcastPlaylistItem.addItem(item: item, for: index)
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
