import UIKit

final class PlaylistsViewController: BaseTableViewController {
    
    weak var delegate: PlaylistsViewControllerDelegate?
    
    var dataSource = PlaylistViewControllerDataSource()
    
    var entryPop: EntryPopover!

    override func viewDidLoad() {
        super.viewDidLoad()
        entryPop = EntryPopover()
        title = "Playlists"
        entryPop.delegate = self
        tableView.dataSource = dataSource
        tableView.backgroundColor = .lightGray
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        tableView.delegate = self
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(addPlaylist))
        rightButtonItem.tintColor = Colors.brightHighlight
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.playlistDataStack.fetchFromCore()
    }
}
