import UIKit
import CoreData

//protocol PlaylistTabDelegate: CoordinatorDelegate {
//    func updatePodcast(with playlistId: String)
//}


final class PlaylistsTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    var testItems = [String]()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let playlistsViewController = navigationController.viewControllers[0] as! PlaylistsViewController
        playlistsViewController.delegate = self
    }
    
    func setup() {
        let playlistsViewController = navigationController.viewControllers[0] as! PlaylistsViewController
        playlistsViewController.delegate = self
    }
}

extension PlaylistsTabCoordinator: PlaylistsViewControllerDelegate {
    
    func didAssignPlaylist(with id: String) {
        delegate?.updatePodcast(with: id)
        print(id)
    }

    
    func didAssignPlaylist(playlist: PodcastPlaylist) {
        
    }

    func didAssign(podcast: PodcastPlaylistItem) {
        
    }

    
    func logout(tapped: Bool) {
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.transitionCoordinator(type: .app, dataSource: dataSource)
    }
    
    func didSelect(at index: Int, with playlist: Playlist) {
        let playlistViewController = PlaylistViewController(index: index)
        navigationController.viewControllers.append(playlistViewController)
    }
}


class PlaylistCoreData {
    
    var testItems = [String]()
    
    func core() {
        var playlist: PodcastPlaylist?
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.coreData.managedContext
        let podcastFetch: NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        do {
            let results = try managedContext.fetch(podcastFetch)
            var podcast: [PodcastPlaylistItem]
            for item in results {
                var currentPlaylistItem: PodcastPlaylistItem?
                let managedContext = appDelegate.coreData.managedContext
                let podcastPlaylistItemFetch: NSFetchRequest<PodcastPlaylistItem> = PodcastPlaylistItem.fetchRequest()
                podcastPlaylistItemFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(PodcastPlaylistItem.playlistId), item.playlistId!)
                let results = try managedContext.fetch(podcastPlaylistItemFetch)
                do {
                    let results = try managedContext.fetch(podcastPlaylistItemFetch)
                    if results.count > 0 {
                        for item in results {
                            if let newTitle = item.episodeTitle {
                                testItems.append(newTitle)
                            }
                        }
                    } else {
                        currentPlaylistItem = PodcastPlaylistItem(context: managedContext)
                        currentPlaylistItem?.episodeTitle = "test"
                        try managedContext.save()
                    }
                } catch let error as NSError {
                    print("Fetch error: \(error) description: \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}

