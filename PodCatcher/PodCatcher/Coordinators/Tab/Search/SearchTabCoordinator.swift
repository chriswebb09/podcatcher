import UIKit

final class SearchTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    
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
        let searchViewController = navigationController.viewControllers[0] as! SearchViewController
        searchViewController.delegate = self
    }
}

extension SearchTabCoordinator: SearchViewControllerDelegate {
    
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
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        let store = SearchResultsDataStore()
        store.pullFeed(for: feedUrlString) { response in
            guard let episodes = response.0 else { print("no"); return }
            DispatchQueue.main.async {
                resultsList.episodes = episodes
                resultsList.collectionView.reloadData()
                self.navigationController.viewControllers.append(resultsList)
            }
        }
    }
}

extension SearchTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        let playerView = PlayerView()
        var playerPodcast = podcast
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        playerPodcast.episodes = episodes
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: playerPodcast, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.alpha = 0
        navigationController.viewControllers.append(playerViewController)
    }
}

extension SearchTabCoordinator: PlayerViewControllerDelegate {
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.coreData.managedContext
//        let item = PodcastPlaylistItem(context: managedContext)
//        let image = playerView.albumImageView.image
//        let podcastArtImageData = UIImageJPEGRepresentation(image!, 1) as? Data
//        item.artwork = podcastArtImageData as! NSData
//        item.audioUrl = caster.episodes[index].audioUrlString
//        item.artworkUrl = caster.podcastArtUrlString
//        item.artistId = caster.id
//        item.episodeTitle = caster.episodes[index].title
//        item.episodeDescription = caster.episodes[index].description
//        item.stringDate = caster.episodes[index].date
//        print("here")
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
         let playlistViewController = controller?.tabBarController?.viewControllers?[1].navigationController?.viewControllers[0] as! PlaylistsViewController
        
        playlistViewController.tableView.reloadData()
        
        //        let playlistViewController = PlaylistsViewController()
        //        DispatchQueue.main.async {
        //            self.navigationController.viewControllers.append(playlistViewController)
        //        }
    }
    
   
}
