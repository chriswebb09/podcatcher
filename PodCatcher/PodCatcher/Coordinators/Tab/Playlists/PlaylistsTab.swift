import UIKit
import CoreData

final class PlaylistsTabCoordinator: NavigationCoordinator, PlaylistsCoordinator {
    func editTapped(tapped: Bool) {
        let playlistsViewController = navigationController.viewControllers[0] as! PlaylistsViewController
        
        playlistsViewController.mode = playlistsViewController.mode == .edit ? .add : .edit
        
        if playlistsViewController.leftButtonItem != nil {
            playlistsViewController.leftButtonItem.title = playlistsViewController.mode == .edit ? "Done" : "Edit"
        }
        
        DispatchQueue.main.async {
            playlistsViewController.tableView.reloadData()
        }
        //        @objc func edit() {
        //            mode = mode == .edit ? .add : .edit
        //            if navigationItem.leftBarButtonItem != nil {
        //                leftButtonItem.title = mode == .edit ? "Done" : "Edit"
        //            }
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    var podcastItem: PodcastPlaylistItem!
    var testItems = [String]()
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
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
        playlistsViewController.mediaDataSource = dataSource
    }
    
    
}

extension PlaylistsTabCoordinator: PlaylistsViewControllerDelegate {
    
    func playlistSelected(for caster: PodcastPlaylist) {
        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer(), playlist: caster)
        playlist.playlistId = caster.playlistId!
        playlist.playlistTitle = caster.playlistName!
        navigationController.pushViewController(playlist, animated: false)
    }
    
    func didAssignPlaylist(with id: String) {
        delegate?.updatePodcast(with: id)
        let item = PodcastPlaylistItem(context: managedContext)
        item.playlistId = id
        let controller = navigationController.viewControllers.last as! PlaylistsViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 2
    }
}
