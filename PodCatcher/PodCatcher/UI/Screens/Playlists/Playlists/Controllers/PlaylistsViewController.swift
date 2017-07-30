import UIKit
import CoreData

protocol PlaylistsViewControllerDelegate: class {
    func didAssignPlaylist(with id: String)
}

final class PlaylistsViewController: BaseTableViewController {
    
    weak var delegate: PlaylistsViewControllerDelegate?
    var mediaDataSource: BaseMediaControllerDataSource!
    var reference: PlaylistsReference = .checkList
    var playlistDataStack = PlaylistsCoreDataStack()
    var currentPlaylistID: String = ""
    var entryPop: EntryPopover = EntryPopover()
    var mode: PlaylistsInteractionMode = .add
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
    var testDataSource: TableViewDataSource<PlaylistsViewController>!
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
        fetchedResultsController.fetchRequest
        testDataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "PlaylistCell", fetchedResultsController: fetchedResultsController, delegate: self)
        testDataSource.reloadData()
        tableView.dataSource = testDataSource
    }
    
    func edit() {
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
            DispatchQueue.main.async {
                let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Pressing okay will delete this playlist.", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                    actionSheetController.dismiss(animated: false, completion: nil)
                }
                let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .destructive) { action in
                    self.editFor(indexPath: indexPath)
                }
                actionSheetController.addAction(cancelAction)
                actionSheetController.addAction(okayAction)
                self.present(actionSheetController, animated: true, completion: nil)
            }
        case .add:
            addFor(indexPath: indexPath)
        }
    }
    
    func addFor(indexPath: IndexPath) {
        guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
        switch reference {
        case .addPodcast:
            add(text: text)
        case .checkList:
            add(text: text, from: indexPath)
        }
    }
    
    func add(text: String) {
        reference = .checkList
        DispatchQueue.main.async { self.testDataSource.reloadData() }
        delegate?.didAssignPlaylist(with: text)
    }
    
    func add(text: String, from indexPath: IndexPath) {
        guard let title = fetchedResultsController.object(at: indexPath).playlistName else { return }
        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer())
        playlist.playlistId = text
        playlist.playlistTitle = title
        navigationController?.pushViewController(playlist, animated: false)
    }
    
    func editFor(indexPath: IndexPath) {
        
        let id = fetchedResultsController.object(at: indexPath).playlistId
        persistentContainer.performBackgroundTask { _ in
            self.managedContext.delete(self.fetchedResultsController.object(at: indexPath))
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PodcastPlaylistItem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.managedContext.execute(deleteRequest)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                self.showError(errorString: "\(error.localizedDescription)")
            }
            self.testDataSource.reloadData()
            do {
                try self.managedContext.save()
            } catch let error {
                self.showError(errorString: "\(error.localizedDescription)")
            }
            if let count = self.fetchedResultsController.fetchedObjects?.count {
                if count == 0 {
                    self.mode = .add
                    self.leftButtonItem.title = "Edit"
                }
            }
        }
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        playlistDataStack.save(name: name, uid: "none")
        testDataSource.reloadData()
    }
    
    func addPlaylist() {
        UIView.animate(withDuration: 0.05) {
            self.entryPop.showPopView(viewController: self)
            self.entryPop.popView.isHidden = false
        }
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        entryPop.hidePopView(viewController: self)
        tableView.reloadData()
        testDataSource.reloadData()
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
        if let artWorkImageData = object.artwork as? Data, let artworkImage = UIImage(data: artWorkImageData) {
            cell.configure(image: artworkImage, title: object.playlistName!, mode: cellMode)
        } else {
            cell.configure(image: #imageLiteral(resourceName: "light-placehoder-2"), title: object.playlistName!, mode: cellMode)
        }
    }
}
