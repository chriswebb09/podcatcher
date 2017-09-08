import UIKit
import CoreData

final class BrowseTabCoordinator: NavigationCoordinator, BrowseCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var feedStore = FeedCoreDataStack()
    var dataSource: BaseMediaControllerDataSource!
    var store = SearchResultsDataStore()
    var interactor = SearchResultsIteractor()
    let globalDefault = DispatchQueue.global()
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    let concurrent = DispatchQueue(label: "concurrentBackground",
                                   qos: .background,
                                   attributes: .concurrent,
                                   autoreleaseFrequency: .inherit,
                                   target: nil)
    
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
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getCasterWorkaround { items, error in
                if error != nil {
                    DispatchQueue.main.async {
                        let informationView = InformationView(data: "", icon: #imageLiteral(resourceName: "sad-face"))
                        informationView.setIcon(icon: #imageLiteral(resourceName: "sad-face"))
                        informationView.setLabel(text: "Oops! Unable to connect to iTunes server.")
                        informationView.frame = UIScreen.main.bounds
                        browseViewController.view = informationView
                        browseViewController.view.layoutSubviews()
                        browseViewController.hideLoadingView(loadingPop: browseViewController.loadingPop)
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
    
    func getCasterWorkaround(completion: @escaping ([CasterSearchResult]?, Error?) -> Void) {
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        var results = [CasterSearchResult]()
        let topPodcastGroup = DispatchGroup()
        var ids: [String] = ["201671138", "1268047665", "1264843400", "1212558767", "1200361736", "1150510297", "1097193327", "1250180134", "523121474", "1074507850", "173001861", "1028908750"]
        for i in 0..<ids.count {
            self.globalDefault.async(group: topPodcastGroup) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.interactor.setLookup(term: ids[i])
                strongSelf.interactor.searchForTracksFromLookup { result, arg  in
                    if let error = arg {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
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
                browseViewController.hideLoadingView(loadingPop: browseViewController.loadingPop)
                completion(results, nil)
            }
        }
        topPodcastGroup.wait()
        print("Done waiting.")
    }
    
    func getCaster(completion: @escaping ([CasterSearchResult]?, Error?) -> Void) {
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        
        getTopItems { [weak self] newItems, error in
            guard let strongSelf = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            var results = [CasterSearchResult]()
            let topPodcastGroup = DispatchGroup()
            guard let newItems = newItems else { return }
            for i in 0..<newItems.count {
                strongSelf.globalDefault.async(group: topPodcastGroup) {
                    strongSelf.interactor.setLookup(term: newItems[i].id)
                    strongSelf.interactor.searchForTracksFromLookup { result, arg  in
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
            topPodcastGroup.notify(queue: strongSelf.globalDefault) {
                print("Notify received, done waiting.")
                DispatchQueue.main.async {
                    browseViewController.hideLoadingView(loadingPop: browseViewController.loadingPop)
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
        ApplicationStyling.setupUI()
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.item = caster as! CasterSearchResult
        let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        browseViewController.showLoadingView(loadingPop: browseViewController.loadingPop)
        let store = SearchResultsDataStore()
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            store.pullFeed(for: feedUrlString) {  response, arg in
                guard let episodes = response else { return }
                resultsList.episodes = episodes
                DispatchQueue.main.async {
                    browseViewController.hideLoadingView(loadingPop: browseViewController.loadingPop)
                    strongSelf.navigationController.pushViewController(resultsList, animated: false)
                    browseViewController.collectionView.isUserInteractionEnabled = true
                    
                }
            }
        }
    }
}

extension BrowseTabCoordinator: PodcastListViewControllerDelegate {
    
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let playerViewController = PlayerViewController(index: index, caster: playerPodcast, image: nil)
            playerViewController.delegate = strongSelf
            strongSelf.navigationController.navigationBar.isTranslucent = true
            strongSelf.navigationController.navigationBar.alpha = 0
            strongSelf.navigationController.pushViewController(playerViewController, animated: false)
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
        navigationController.popViewController(animated: false)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}
