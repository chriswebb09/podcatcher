import UIKit
import CoreData

final class PlaylistsViewController: BaseTableViewController {
    
    weak var delegate: PlaylistsViewControllerDelegate?
    var mediaDataSource: BaseMediaControllerDataSource!
    var reference: PlaylistsReference = .checkList
    var playlistDataStack = PlaylistsCoreDataStack()
    var currentPlaylistID: String = ""
    var entryPop: EntryPopover!
    var mode: PlaylistsInteractionMode = .add
    var index: Int!
    var userID: String!
    var item: CasterSearchResult!
    var background = UIView()
    var addItemToPlaylist: PodcastPlaylistItem?
    var fetchedResultsController:NSFetchedResultsController<PodcastPlaylist>!
    
    private let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = mediaDataSource.user {
            self.userID = user.userId
        } else {
            self.userID = "none"
        }
        entryPop = EntryPopover()
        title = "Playlists"
        entryPop.delegate = self
        background.frame = UIScreen.main.bounds
        view.addSubview(background)
        view.sendSubview(toBack: background)
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.lightGray.cgColor], layer: background.layer, bounds: tableView.bounds)
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        tableView.delegate = self
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addPlaylist))
        leftButtonItem  = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        rightButtonItem.tintColor = Colors.brightHighlight
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        reloadData()
    }
    
    func edit() {
        mode = mode == .edit ? .add : .edit
        if navigationItem.leftBarButtonItem != nil {
            leftButtonItem.title = mode == .edit ? "Done" : "Edit"
        }
        tableView.reloadData()
    }
}

extension PlaylistsViewController: ReloadableTable, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            if count <= 0 {
                tableView.backgroundView?.addSubview(emptyView)
                navigationItem.leftBarButtonItem = nil
                
            } else {
                emptyView?.removeFromSuperview()
                navigationItem.setLeftBarButton(leftButtonItem, animated: false)
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistCell
        switch mode {
        case .add:
            cell.mode = .select
        case .edit:
            cell.mode = .delete
        }
        if let art = fetchedResultsController.object(at: indexPath).artwork {
            let image = UIImage(data: art as Data)
            cell.albumArtView.image = image
        } else {
            cell.albumArtView.image = #imageLiteral(resourceName: "light-placehoder-2")
        }
        let text = fetchedResultsController.object(at: indexPath).playlistName
        cell.titleLabel.text = text?.uppercased()
        cell.numberOfItemsLabel.text = "Podcasts"
        return cell
    }
}

extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mode {
        case .edit:
            editFor(indexPath: indexPath)
        case .add:
            guard let text = fetchedResultsController.object(at: indexPath).playlistId else { return }
            switch reference {
            case .addPodcast:
                reference = .checkList
                DispatchQueue.main.async {
                    self.reloadData()
                }
                delegate?.didAssignPlaylist(with: text)
            case .checkList:
                guard let title = fetchedResultsController.object(at: indexPath).playlistName else { return }
                let playlist = PlaylistViewController(index: 0)
                playlist.playlistId = text
                playlist.playlistTitle = title
                navigationController?.pushViewController(playlist, animated: false)
            }
        }
    }
    
    func editFor(indexPath: IndexPath) {
        let id = fetchedResultsController.object(at: indexPath).playlistId
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(fetchedResultsController.object(at: indexPath))
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PodcastPlaylistItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let playlistId = id else { return }
        fetchRequest.predicate = NSPredicate(format: "playlistId == %@", playlistId)
        
        do {
            try appDelegate.persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            showError(errorString: "\(error.localizedDescription)")
        }
        
        reloadData()
        
        do {
            try context.save()
        } catch let error {
            showError(errorString: "\(error.localizedDescription)")
        }
        if let count = fetchedResultsController.fetchedObjects?.count {
            if count == 0 {
                mode = .add
                leftButtonItem.title = "Edit"
            }
        }
    }
    
    func showError(errorString: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
            actionSheetController.dismiss(animated: false, completion: nil)
        }
        actionSheetController.addAction(okayAction)
        present(actionSheetController, animated: false)
    }
}

extension PlaylistsViewController: EntryPopoverDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        playlistDataStack.save(name: name, uid: userID)
        reloadData()
    }
    
    func addPlaylist() {
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.entryPop.showPopView(viewController: strongSelf)
            strongSelf.entryPop.popView.isHidden = false
        }
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        entryPop.hidePopView(viewController: self)
        tableView.reloadData()
    }
}
