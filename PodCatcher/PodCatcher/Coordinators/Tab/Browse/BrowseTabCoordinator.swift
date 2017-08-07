import UIKit
import CoreData

final class BrowseTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var fetcher = SearchResultsFetcher()
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    var playlistItem: PodcastPlaylistItem!
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
            let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
            concurrentQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.getCaster { items in
                    if browseViewController.dataSource.items.count > 0 {
                        guard let urlString = browseViewController.dataSource.items[0].podcastArtUrlString else { return }
                        guard let imageUrl = URL(string: urlString) else { return }
                        browseViewController.topView.podcastImageView.downloadImage(url: imageUrl)
                    }
                }
            }
        }
    }
    
    func getTopItems(completion: @escaping ([TopItem]) -> Void) {
        let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
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
    
    func getCaster(completion: @escaping ([CasterSearchResult]) -> Void) {
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        getTopItems { newItems in
            var results = [CasterSearchResult]()
            for item in newItems {
                self.fetcher.setLookup(term: item.id)
                self.fetcher.searchForTracksFromLookup { result, arg  in
                    guard let resultItem = result else { return }
                    resultItem.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = CasterSearchResult(json: resultingData) {
                            results.append(caster)
                            DispatchQueue.main.async {
                                browseViewController.dataSource.items.append(caster)
                                browseViewController.collectionView.reloadData()
                                if let artUrl = results[0].podcastArtUrlString, let url = URL(string: artUrl) {
                                    browseViewController.topView.podcastImageView.downloadImage(url: url)
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion(results)
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
        let concurrent = DispatchQueue(label: "concurrentBackground", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            store.pullFeed(for: feedUrlString) { response, arg  in
                guard let episodes = response else { return }
                resultsList.episodes = episodes
                DispatchQueue.main.async {
                    resultsList.collectionView.reloadData()
                    strongSelf.navigationController.pushViewController(resultsList, animated: false)
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
        let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
        playerViewController.delegate = self
        navigationController.pushViewController(playerViewController, animated: false)
    }
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        var playerPodcast = podcast
        playerPodcast.episodes = episodes
        playerPodcast.index = index
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
                playerViewController.delegate = strongSelf
                strongSelf.navigationController.navigationBar.isTranslucent = true
                strongSelf.navigationController.navigationBar.alpha = 0
                strongSelf.navigationController.pushViewController(playerViewController, animated: false)
            }
        }
    }
}

extension BrowseTabCoordinator: PlayerViewControllerDelegate {
    func playPaused(tapped: Bool) {
        
    }
    
    func backButton(tapped: String) {
        print(tapped)
    }
    
    func playButton(tapped: String) {
        print(tapped)
    }
    
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
        
        playlists.podcastDelegate = self
        let podcastItem = PodcastPlaylistItem(context: managedContext)
        podcastItem.audioUrl = item.episodes[index].audioUrlSting
        podcastItem.artistFeedUrl = item.feedUrl
        podcastItem.date = NSDate()
        podcastItem.duration = 0
        podcastItem.artistName = item.podcastArtist
        podcastItem.stringDate = String(describing: NSDate())
        podcastItem.artworkUrl = item.podcastArtUrlString
        podcastItem.episodeTitle = item.episodes[index].title
        podcastItem.episodeDescription = item.episodes[index].description
        if let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
            UIImage.downloadImage(url: url) { image in
                let podcastArtImageData = UIImageJPEGRepresentation(image, 1)
                podcastItem.artwork = podcastArtImageData as? NSData
            }
        }
        self.playlistItem = podcastItem
    }
    
    
    func skipButton(tapped: String) {
        print(tapped)
    }
    
    func pauseButton(tapped: String) {
        print(tapped)
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}

extension BrowseTabCoordinator: PodcastDelegate {
    
    func didAssignPlaylist(playlist: PodcastPlaylist) {
        playlist.addToPodcast(playlistItem)
        playlistItem.playlist = playlist
        do {
            if let context = playlistItem.managedObjectContext {
                try! context.save()
            }
        }
    }
    
    func didDeletePlaylist() {
        
    }
}
