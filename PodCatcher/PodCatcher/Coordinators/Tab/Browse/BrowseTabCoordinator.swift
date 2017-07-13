import UIKit

final class BrowseTabCoordinator: NavigationCoordinator {
    
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
        let homeViewController = navigationController.viewControllers[0] as! BrowseViewController
        homeViewController.delegate = self
    }
    
    func setup() {
        let homeViewController = navigationController.viewControllers[0] as! BrowseViewController
        let mainStore = MainStore()
        store.pullFeedTopPodcasts { data, error in
            UserDefaults.standard.set(Date(), forKey: "topItems")
            guard let data = data else { return }
            var results = [CasterSearchResult]()
            for item in data {
                self.fetcher.setLookup(term: item.id)
                self.fetcher.searchForTracksFromLookup { result in
                    guard let resultItem = result.0 else { return }
                    resultItem.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = CasterSearchResult(json: resultingData) {
                            results.append(caster)
                            homeViewController.collectionView.reloadData()
                            mainStore.save(podcastItem: caster)
                        }
                    }
                    DispatchQueue.main.async {
                        homeViewController.dataSource.items = results
                        guard let urlString = homeViewController.dataSource.items[0].podcastArtUrlString else { return }
                        homeViewController.collectionView.reloadData()
                        guard let imageUrl = URL(string: urlString) else { return }
                        homeViewController.topView.podcastImageView.downloadImage(url: imageUrl)
                    }
                }
            }
        }
    }
}

extension BrowseTabCoordinator: BrowseViewControllerDelegate {
    
    func logout(tapped: Bool) {
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func didSelect(at index: Int, with caster: PodcastSearchResult) {
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.dataSource.user = dataSource.user
        resultsList.item = caster as! CasterSearchResult
        let homeVC = navigationController.viewControllers[0] as! BrowseViewController
        resultsList.currentPlaylistID = homeVC.currentPlaylistId
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        dump(resultsList.item)
        let store = SearchResultsDataStore()
        store.pullFeed(for: feedUrlString) { response in
            guard let episodes = response.0 else {
                return
            }
            DispatchQueue.main.async {
                resultsList.episodes = episodes
                resultsList.collectionView.reloadData()
                self.navigationController.viewControllers.append(resultsList)
            }
        }
    }
    
    func didSelect(at index: Int) {
        let homeViewController = navigationController.viewControllers[0] as! BrowseViewController
        let data = homeViewController.dataSource.topStore.podcasts
        let newItem = data[index]
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.dataSource.user = dataSource.user
        var caster = CasterSearchResult()
        caster.feedUrl = newItem.value(forKey: "podcastFeedUrlString") as? String
        guard let imageData = newItem.value(forKey: "podcastArt") as? Data else { return }
        resultsList.topView.podcastImageView.image = UIImage(data: imageData)
        guard let feedUrlString = caster.feedUrl else { return }
        
        let store = SearchResultsDataStore()
        store.pullFeed(for: feedUrlString) { response in
            guard let episodes = response.0 else { return }
            resultsList.episodes = episodes
        }
        DispatchQueue.main.async {
            resultsList.collectionView.reloadData()
            self.navigationController.viewControllers.append(resultsList)
        }
    }
}

extension BrowseTabCoordinator: PodcastListViewControllerDelegate {
    
    
    func didSelect(at index: Int, podcast: CasterSearchResult) {
        let playerView = PlayerView()
        var playerPodcast = podcast
        playerPodcast.index = index
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: playerPodcast, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.viewControllers.append(playerViewController)
    }
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        let playerView = PlayerView()
        let homeVC = navigationController.viewControllers[0] as! BrowseViewController
        var playerPodcast = podcast
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        playerPodcast.episodes = episodes
        playerPodcast.index = index
        
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: playerPodcast, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.alpha = 0
        navigationController.viewControllers.append(playerViewController)
    }
}

extension BrowseTabCoordinator: PlayerViewControllerDelegate {
    
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
    
    func addItemToPlaylist(item: PodcastPlaylistItem) {
        let controller = navigationController.viewControllers.last
        controller?.tabBarController?.selectedIndex = 1
        guard let tab =  controller?.tabBarController else { return }
        let nav = tab.viewControllers?[1] as! UINavigationController
        let playlists = nav.viewControllers[0] as! PlaylistsViewController
        playlists.addItemToPlaylist = item
    }
}
