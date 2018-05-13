import UIKit
import CoreData

final class SearchTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var feedStore = FeedCoreDataStack()
 
    var dataSource: BaseMediaControllerDataSource!
    var persistentContainer: NSPersistentContainer!
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
    func didSelect(at index: Int, with cast: Podcast) {
        let feedUrlString = cast.feedUrl
        let searchViewController = navigationController.viewControllers[0] as! SearchViewController
        
        let resultsList = PodcastListViewController(index: index)
        resultsList.delegate = self 
        let store = SearchResultsDataStore()
        
        let feedPodcast = cast
        feedPodcast.podcastTitle = cast.podcastTitle
        
        store.pullFeed(for: feedUrlString) { response, error  in
            if error != nil {
                print(error?.localizedDescription ?? "unable to get specific error")
                //loadingPop.hideLoadingView(controller: backingVC)
                return
            }
            guard let episodes = response else { return }
            feedPodcast.episodes = episodes
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    //resultsList.title = cast.podcastArtist
//                    if let url = URL(string: cast.podcastArtUrlString) {
//                        resultsList.topView.podcastImageView.downloadImage(url: url)
//                    }
                    resultsList.setDataItem(dataItem: feedPodcast)
                    //  backingVC.loadingPop.hideLoadingView(controller: backingVC)
                  //  strongSelf.navigationController.title = cast.podcastArtist
                    // navigationController.delegate = self
                    strongSelf.navigationController.pushViewController(resultsList, animated: true)
                    //resultsList.setDataItem(dataItem: feedPodcas)
                    
                }
            }
        }
    }

    
    
    
    func logout(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app)
    }
    
    //    func didSelect(at index: Int, with caster: PodcastSearchResult) {
    //        let searchViewController = navigationController.viewControllers[0] as! SearchViewController
    //        let resultsList = SearchResultListViewController(index: index)
    //        DispatchQueue.main.async {
    //            searchViewController.showLoadingView(loadingPop: searchViewController.loadingPop)
    //        }
    //        //resultsList.delegate = self
    //
    //
    ////        guard let feedUrlString =
    ////            //dataItem.feedUrl else { return }
    ////        let store = SearchResultsDataStore()
    ////        concurrent.async { [weak self] in
    ////            guard let strongSelf = self else { return }
    ////            store.pullFeed(for: feedUrlString) { response, arg  in
    ////
    ////                guard let episodes = response else { print("no"); return }
    ////                dataItem.episodes = episodes
    ////                resultsList.setDataItem(dataItem: dataItem)
    ////                DispatchQueue.main.async {
    ////                    searchViewController.hideLoadingView(loadingPop: searchViewController.loadingPop)
    ////                    resultsList.collectionView.reloadData()
    ////                    strongSelf.navigationController.pushViewController(resultsList, animated: false)
    ////                    searchViewController.tableView.isUserInteractionEnabled = true
    ////                }
    ////            }
    ////        }
    //
    //    }
}

extension SearchTabCoordinator: PodcastListViewControllerDelegate {
    func navigateBack(tapped: Bool) {
        
    }
    
    func didSelectPodcastAt(at index: Int, podcast: PodcastItem, with episodes: [Episode]) {
        
    }
    
    
    func addToPlaylist(episde: Episodes) {
        let nav = navigationController.childViewControllers[0] as! UINavigationController
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let playlists = appDelegate.dataStore.playlistDatabase.fetchPlaylists()
            guard let resultsList = nav.viewControllers.last as? PodcastListViewController else { fatalError() }
            // resultsList.buildModal(for: playlists, for: episde)
        }
    }
    
    func goToDescription() {
        print("description")
    }
    
    func saveFeed(item: Podcast, podcastImage: UIImage, episodesCount: Int) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.dataStore.subscriptionDatabase.saveSubscription(manageContext: persistentContainer.viewContext, item: item, podcastImage: podcastImage)
        }
    }
    
    @objc func hideLoadingPop() {
        let nav = navigationController.childViewControllers[0] as! UINavigationController
        //        let backingVC = nav.viewControllers[0] as! BackingViewController
        //        backingVC.loadingPop.hideLoadingView(controller: backingVC)
    }

}
