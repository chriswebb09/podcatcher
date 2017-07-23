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
    
    func swipeFunc() {
        print("swipe")
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
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc))
        swipeRight.direction = .left
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
        cell.addGestureRecognizer(swipeRight)
        return cell
    }
}
