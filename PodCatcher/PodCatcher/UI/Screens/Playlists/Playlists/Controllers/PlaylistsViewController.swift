import UIKit
import CoreData

enum PlaylistsReference {
    case addPodcast, checkList
}

final class PlaylistsViewController: BaseTableViewController {
    
    weak var delegate: PlaylistsViewControllerDelegate?
    var reference: PlaylistsReference = .checkList
    var dataSource = PlaylistViewControllerDataSource()
    var currentPlaylistID: String = ""
    var entryPop: EntryPopover!
    var index: Int!
    var item: CasterSearchResult!
    var addItemToPlaylist: PodcastPlaylistItem?
    var fetchedResultsController:NSFetchedResultsController<PodcastPlaylist>!
    
    private let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryPop = EntryPopover()
        title = "Playlists"
        entryPop.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        tableView.delegate = self
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(addPlaylist))
        rightButtonItem.tintColor = Colors.brightHighlight
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        reloadData()
    }
    
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let fetchRequest:NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: appDelegate.persistentContainer.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
}

extension PlaylistsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistCell
        cell.albumArtView.image = #imageLiteral(resourceName: "light-placehoder-2")
        let text = fetchedResultsController.object(at: indexPath).playlistName
        cell.titleLabel.text = text?.uppercased()
        return cell
    }
    
}


