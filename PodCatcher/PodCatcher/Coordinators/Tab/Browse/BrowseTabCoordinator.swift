import UIKit
import CoreData

final class BrowseTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var fetcher = SearchResultsFetcher()
    let globalDefault = DispatchQueue.global()
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
        self.getCaster { items, error in
            if let error = error {
                DispatchQueue.main.async {
                   // let tabBarController = self.navigationController.tabBarController
                   // tabBarController?.showError(errorString: error.localizedDescription)
                    let informationView = InformationView(data: "Error connection to server", icon: #imageLiteral(resourceName: "sad-face"))
                    informationView.frame = UIScreen.main.bounds
                    browseViewController.view = informationView
                }
            } else {
                if browseViewController.dataSource.items.count > 0 {
                    guard let urlString = browseViewController.dataSource.items[0].podcastArtUrlString else { return }
                    guard let imageUrl = URL(string: urlString) else { return }
                    browseViewController.topView.podcastImageView.downloadImage(url: imageUrl)
                }
            }
        }
    }
    
    func getTopItems(completion: @escaping ([TopItem]?, Error?) -> Void) {
        let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrentQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.store.pullFeedTopPodcasts { data, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                guard let data = data else { return }
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }
    }
    
    func getCaster(completion: @escaping ([CasterSearchResult]?, Error?) -> Void) {
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        getTopItems { newItems, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            var results = [CasterSearchResult]()
            let topPodcastGroup = DispatchGroup()
            guard let newItems = newItems else { return }
            for i in 0..<newItems.count {
                self.globalDefault.async(group: topPodcastGroup) {
                    self.fetcher.setLookup(term: newItems[i].id)
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
            }
            print("Waiting for completion...")
            topPodcastGroup.notify(queue: self.globalDefault) {
                print("Notify received, done waiting.")
                DispatchQueue.main.async {
                    completion(results, nil)
                }
            }
            topPodcastGroup.wait()
            print("Done waiting.")
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
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        let controller = navigationController.viewControllers.last
        guard let tab =  controller?.tabBarController else { return }
        let nav = tab.viewControllers?[1] as! UINavigationController
        let playlists = nav.viewControllers[0] as! PlaylistsViewController
        playlists.reference = .addPodcast
        playlists.index = index
        playlists.item = item
        controller?.tabBarController?.tabBar.alpha = 1
        navigationController.navigationBar.alpha = 1
        playlists.casterItemToSave = item
        controller?.tabBarController?.selectedIndex = 1
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}
