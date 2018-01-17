import UIKit

final class SearchTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var feedStore = FeedCoreDataStack()
    var podcastsData =  PodcastCoreData()
    //var dataSource: BaseMediaControllerDataSource!
    let concurrent = DispatchQueue(label: "concurrentBackground",
                                   qos: .background,
                                   attributes: .concurrent,
                                   autoreleaseFrequency: .inherit,
                                   target: nil)
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childViewControllers = navigationController.viewControllers
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
        delegate?.transitionCoordinator(type: .app)
    }
    
    func didSelect(at index: Int, with caster: PodcastSearchResult) {
        let searchViewController = navigationController.viewControllers[0] as! SearchViewController
        let resultsList = SearchResultListViewController(index: index)
        DispatchQueue.main.async {
            searchViewController.showLoadingView(loadingPop: searchViewController.loadingPop)
        }
        resultsList.delegate = self
        if var dataItem = caster as? CasterSearchResult {

            guard let feedUrlString = dataItem.feedUrl else { return }
            let store = SearchResultsDataStore()
            concurrent.async { [weak self] in
                guard let strongSelf = self else { return }
                store.pullFeed(for: feedUrlString) { response, arg  in
                    
                    guard let episodes = response else { print("no"); return }
                    dataItem.episodes = episodes
                    resultsList.setDataItem(dataItem: dataItem)
                    DispatchQueue.main.async {
                        searchViewController.hideLoadingView(loadingPop: searchViewController.loadingPop)
                        resultsList.collectionView.reloadData()
                        strongSelf.navigationController.pushViewController(resultsList, animated: false)
                        searchViewController.tableView.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}

extension SearchTabCoordinator: PodcastListViewControllerDelegate {
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
    
    
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episode]) {
        
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            var playerPodcast = podcast
            playerPodcast.episodes = episodes
            DispatchQueue.main.async {
                let playerViewController = PlayerViewController(index: index,
                                                                caster: playerPodcast,
                                                                image: nil)
                playerViewController.delegate = strongSelf
                strongSelf.navigationController.setNavigationBarHidden(true, animated: false)
                strongSelf.navigationController.pushViewController(playerViewController, animated: false)
            }
        }
    }
}

extension SearchTabCoordinator: PlayerViewControllerDelegate {
    func saveItemCoreData(item: CasterSearchResult, index: Int, image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        podcastsData.save(title: item.episodes[index].title, audioUrl: item.episodes[index].audioUrlSting, podcasterName: item.podcastArtist!, podcastId: item.artistId, episodeId: item.episodes[index].podcastTitle, podcastImage: imageData! as NSData)
        //  PodcastCoreData
    }
    
    
    func addItemToPlaylist(item: CasterSearchResult, index: Int) {
        let controller = navigationController.viewControllers.last as! PlayerViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 1
        guard let tab =  controller.tabBarController else { return }
        let nav = tab.viewControllers?[1] as! UINavigationController
        let playlists = nav.viewControllers[0] as! PlaylistsViewController
        playlists.reference = .addPodcast
        playlists.index = index
        playlists.item = item
        controller.setupPlayerView()
        delegate?.podcastItem(toAdd: item, with: index)
    }
    
    func navigateBack(tapped: Bool) {
        navigationController.popViewController(animated: false)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.viewControllers.last?.tabBarController?.tabBar.alpha = 1
    }
}
