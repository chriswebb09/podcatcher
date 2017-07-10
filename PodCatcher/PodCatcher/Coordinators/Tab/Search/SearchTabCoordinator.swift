import UIKit

enum TabType {
    case home, playlists, playlist, search, results, player
}

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
    
    func didSelect(at index: Int, podcast: CasterSearchResult) {
        let playerView = PlayerView()
//       // var homeVC = navigationController.viewControllers[0] as! HomeViewController
//        var playerPodcast = podcast
//        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
//        playerPodcast.episodes = episodes
//        playerPodcast.index = index
//        
//        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: playerPodcast, user: dataSource.user)
//        
//        playerViewController.dataSource.currentPlaylistId = homeVC.currentPlaylistId
//        playerViewController.delegate = self
//        navigationController.navigationBar.isTranslucent = true
//        navigationController.navigationBar.alpha = 0
//        // controller?.tabBarController?.selectedIndex = 1
//        navigationController.viewControllers.append(playerViewController)
    }

    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        let playerView = PlayerView()
        var searchVC = navigationController.viewControllers[0] as! SearchViewController
        var playerPodcast = podcast
        CALayer.createGradientLayer(with: [UIColor(red:0.94, green:0.31, blue:0.81, alpha:1.0).cgColor, UIColor(red:0.32, green:0.13, blue:0.70, alpha:1.0).cgColor], layer: playerView.backgroundView.layer, bounds: UIScreen.main.bounds)
        playerPodcast.episodes = episodes
        let playerViewController = PlayerViewController(playerView: playerView, index: index, caster: playerPodcast, user: dataSource.user)
        playerViewController.delegate = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers.append(playerViewController)

    }
}

extension SearchTabCoordinator: PlayerViewControllerDelegate {
 
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
        let controller = navigationController.viewControllers.last as! PlayerViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 1
        guard let tab =  controller.tabBarController else { return }
        let nav = tab.viewControllers?[1] as! UINavigationController
        let playlists = nav.viewControllers[0] as! PlaylistsViewController
        playlists.reference = .addPodcast
        playlists.index = index
        playlists.item = item
        controller.playerView.alpha = 1
        controller.view.bringSubview(toFront: controller.playerView)
        controller.tabBarController?.tabBar.alpha = 1
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
        controller?.tabBarController?.selectedIndex = 2
      //  let playlistViewController = controller?.tabBarController?.viewControllers?[1].navigationController?.viewControllers[0] as! PlaylistsViewController
     //   playlistViewController.tableView.reloadData()
    }
    
    
}
