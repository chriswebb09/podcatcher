import UIKit
import CoreData

final class PlaylistsViewController: BaseTableViewController {
    
    weak var podcastDelegate: PodcastDelegate?
    
    weak var delegate: PlaylistsViewControllerDelegate?
    var mediaDataSource: BaseMediaControllerDataSource!
    var itemToSave: PodcastPlaylistItem!
    var reference: PlaylistsReference = .checkList
    var playlistDataStack = PlaylistsCoreData()
    var currentPlaylistID: String = ""
    var entryPop: EntryPopover = EntryPopover()
    var mode: PlaylistsInteractionMode = .add
    var casterItemToSave: CasterSearchResult!
    var index: Int!
    var item: CasterSearchResult!
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
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
        title = "Playlists"
        entryPop.delegate = self
        background.frame = UIScreen.main.bounds
        view.addSubview(background)
        view.sendSubview(toBack: background)
        
        tableView.backgroundColor = .clear
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.lightGray.cgColor], layer: background.layer, bounds: tableView.bounds)
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        tableView.delegate = self
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addPlaylist))
        leftButtonItem  = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        rightButtonItem.tintColor = Colors.brightHighlight
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        playlistsDataSource = TableViewDataSource(tableView: tableView, identifier: "PlaylistCell", fetchedResultsController: fetchedResultsController, delegate: self)
        playlistsDataSource.reloadData()
        tableView.dataSource = playlistsDataSource
        playlistsDataSource.setIcon(icon: #imageLiteral(resourceName: "podcast-icon").withRenderingMode(.alwaysTemplate))
        playlistsDataSource.setText(text: "Create Playlists For Your Favorite Podcasts")
        if playlistsDataSource.itemCount == 0 {
            navigationItem.leftBarButtonItem = nil
        }
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
                    podcastItem.artwork = podcastArtImageData as? NSData
                }
            }
            
            let playlist = fetchedResultsController.object(at: indexPath)
            podcastItem.playlist = playlist
            do {
                if let context = playlist.managedObjectContext {
                    try! context.save()
                }
            } catch let error {
                print(error.localizedDescription)
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
        let title = fetchedResultsController.object(at: indexPath)
        let casts = fetchedResultsController.object(at: indexPath)
        let podcasts = casts.podcast
        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer(), playlist: casts)
        playlist.playlistId = text
        delegate?.playlistSelected(for: title)
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
        persistentContainer.performBackgroundTask { _ in
            self.managedContext.delete(self.fetchedResultsController.object(at: indexPath))
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PodcastPlaylistItem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.managedContext.execute(deleteRequest)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            self.playlistsDataSource.reloadData()
            
            do {
                try self.managedContext.save()
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
        switch mode {
        case .add:
            cellMode = .select
        case .edit:
            cellMode = .delete
        }
        
        if let artWorkImageData = object.artwork, let artworkImage = UIImage(data: Data.init(referencing: artWorkImageData)) {
            cell.configure(image: artworkImage, title: object.playlistName!, mode: cellMode)
        } else {
            if let name = object.playlistName {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: name, mode: cellMode)
            } else {
                cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: "temp", mode: cellMode)
            }
        }
    }
}
