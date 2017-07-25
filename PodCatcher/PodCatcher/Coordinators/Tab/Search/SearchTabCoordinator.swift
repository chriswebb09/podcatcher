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
        let searchViewController = navigationController.viewControllers[0] as! SearchViewController
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        resultsList.dataSource = dataSource
        resultsList.dataSource.user = dataSource.user
        resultsList.item = caster as! CasterSearchResult
        guard let feedUrlString = resultsList.item.feedUrl else { return }
        let store = SearchResultsDataStore()
        let concurrent = DispatchQueue(label: "concurrentBackground", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            store.pullFeed(for: feedUrlString) { response in
                guard let episodes = response.0 else { print("no"); return }
                resultsList.episodes = episodes
                DispatchQueue.main.async {
                    resultsList.collectionView.reloadData()
                    strongSelf.navigationController.viewControllers.append(resultsList)
                    searchViewController.tableView.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension SearchTabCoordinator: PodcastListViewControllerDelegate {
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episodes]) {
        let concurrent = DispatchQueue(label: "concurrentBackground", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            var playerPodcast = podcast
            playerPodcast.episodes = episodes
            let playerViewController = PlayerViewController(index: index, caster: playerPodcast, user: strongSelf.dataSource.user, image: nil)
            playerViewController.delegate = strongSelf
            DispatchQueue.main.async {
                strongSelf.navigationController.setNavigationBarHidden(true, animated: false)
                strongSelf.navigationController.viewControllers.append(playerViewController)
            }
        }
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
}
