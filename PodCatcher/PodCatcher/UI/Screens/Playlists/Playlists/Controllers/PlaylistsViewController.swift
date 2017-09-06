import UIKit
import CoreData

final class PlaylistsViewController: BaseTableViewController {
    
    weak var podcastDelegate: PodcastDelegate?
    var coordinator: PlaylistsCoordinator?
    weak var delegate: PlaylistsViewControllerDelegate?
    var mediaDataSource: BaseMediaControllerDataSource!
    var itemToSave: PodcastPlaylistItem!
    var reference: PlaylistsReference = .checkList
    var playlistDataStack = PlaylistsCoreData()
    var currentPlaylistID: String = ""
    var entryPop: EntryPopover = EntryPopover()
    var mode: PlaylistsInteractionMode = .add
    var casterItzemToSave: CasterSearchResult!
    var index: Int!
    
    var item: CasterSearchResult!
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    lazy var fetchedResultsController:NSFetchedResultsController<PodcastPlaylist> = {
        let fetchRequest:NSFetchRequest<PodcastPlaylist> = PodcastPlaylist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        var controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        try! controller.performFetch()
        return controller
    }()
    
    var background = UIView()
    var addItemToPlaylist: PodcastPlaylistItem?
    var playlistsDataSource: TableViewDataSource<PlaylistsViewController>!
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        playlistsDataSource = TableViewDataSource(tableView: tableView, identifier: "PlaylistCell", fetchedResultsController: fetchedResultsController, delegate: self)
        leftButtonItem  = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addPlaylist))
        coordinator?.viewDidLoad(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mode = .add
    }
    
    @objc func edit() {
        mode = mode == .edit ? .add : .edit
        if navigationItem.leftBarButtonItem != nil {
            leftButtonItem.title = mode == .edit ? "Done" : "Edit"
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mode {
        case .edit:
            editMode(indexPath: indexPath)
        case .add:
            addFor(indexPath: indexPath)
        }
    }
    
    func addFor(indexPath: IndexPath) {
        guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
        switch reference {
        case .addPodcast:
            let podcastItem = PodcastPlaylistItem(context: fetchedResultsController.managedObjectContext)
            podcastItem.audioUrl = item.episodes[index].audioUrlSting
            podcastItem.artistFeedUrl = item.feedUrl
            podcastItem.date = NSDate()
            podcastItem.duration = 0
            podcastItem.artistName = item.podcastArtist
            podcastItem.stringDate = String(describing: NSDate())
            podcastItem.artworkUrl = item.podcastArtUrlString
            podcastItem.episodeTitle = item.episodes[index].title
            podcastItem.episodeDescription = item.episodes[index].description
            if let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
                UIImage.downloadImage(url: url) { image in
                    let podcastArtImageData = UIImageJPEGRepresentation(image, 1)
                    if let podcastArtImageData = podcastArtImageData {
                        podcastItem.artwork = NSData.init(data: podcastArtImageData)
                    }
                }
            }
            let playlist = fetchedResultsController.object(at: indexPath)
            podcastItem.playlist = playlist
            playlist.addToPodcast(podcastItem)
            if let context = podcastItem.managedObjectContext {
                context.performAndWait() {
                    do {
                        try context.save()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        case .checkList:
            print("checklist")
            addNewPlaylist(text: text, from: indexPath)
        }
        reference = .checkList
    }
    
    
    func add(text: String) {
        reference = .checkList
        DispatchQueue.main.async { self.playlistsDataSource.reloadData() }
        delegate?.didAssignPlaylist(with: text)
    }
    
    func addToPlaylist(with name: String) {
        reference = .checkList
        DispatchQueue.main.async {
            self.playlistsDataSource.reloadData()
        }
    }
    
    func addNewPlaylist(text: String, from indexPath: IndexPath) {
        let casts = fetchedResultsController.object(at: indexPath)
        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer(), playlist: casts)
        playlist.playlistId = text
        delegate?.playlistSelected(for: casts)
    }
    
    func editMode(indexPath: IndexPath) {
        guard let title = fetchedResultsController.object(at: indexPath).playlistName else { return }
        DispatchQueue.main.async {
            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Pressing okay will delete \(title).", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                actionSheetController.dismiss(animated: false, completion: nil)
            }
            let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
                self.removeFor(indexPath: indexPath)
            }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(okayAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func removeFor(indexPath: IndexPath) {
        
        let item = self.fetchedResultsController.object(at: indexPath)
        
        guard let podcast = item.podcast else { return }
        for (_, podcast) in (podcast.enumerated()) {
            let pod = podcast as! PodcastPlaylistItem
            LocalStorageManager.deleteSavedItem(itemUrlString: pod.audioUrl!)
        }
        self.managedContext.delete(item)
        do {
            try self.managedContext.save()
            self.playlistsDataSource.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
        if let count = self.fetchedResultsController.fetchedObjects?.count {
            if count == 0 {
                self.mode = .add
                self.leftButtonItem.title = "Edit"
            }
            if self.playlistsDataSource.itemCount == 0 {
                DispatchQueue.main.async {
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        }
        
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        playlistDataStack.save(name: name, uid: "none")
        playlistsDataSource.reloadData()
        if playlistsDataSource.itemCount > 0 {
            navigationItem.leftBarButtonItem = leftButtonItem
        }
    }
    
    @objc func addPlaylist() {
        UIView.animate(withDuration: 0.05) {
            self.entryPop.showPopView(viewController: self)
            self.entryPop.popView.isHidden = false
        }
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    @objc func hidePop() {
        entryPop.hidePopView(viewController: self)
        tableView.reloadData()
        playlistsDataSource.reloadData()
    }
}

extension PlaylistsViewController: TableViewDataSourceDelegate {
    
    typealias Cell = PlaylistCell
    typealias Object = PodcastPlaylist
    
    func configure(_ cell: PlaylistCell, for object: PodcastPlaylist) {
        
        var cellMode: PlaylistCellMode = .select
        
        cellMode = mode == .add ? .select : .delete
        
        if let podcast = object.podcast as? Set<PodcastPlaylistItem>, podcast.count > 0 {
            for (i, n) in podcast.enumerated() {
                if i == 0 {
                    if let data = n.artwork, let artworkImage = UIImage(data: Data.init(referencing: data)) {
                        if let count = object.podcast?.count {
                            cell.configure(image: artworkImage, title: object.playlistName!, subtitle: "Episodes: \(count)", mode: cellMode)
                        }
                    }
                }
            }
        } else {
            if let name = object.playlistName, let count = object.podcast?.count {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: name, subtitle: "Episodes: \(count)", mode: cellMode)
            } else {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: "temp", subtitle: "Episodes: Unknown", mode: cellMode)
            }
        }
    }
}
