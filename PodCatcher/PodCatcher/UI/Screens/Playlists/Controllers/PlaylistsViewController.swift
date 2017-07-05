import UIKit

class PlaylistsViewController: BaseTableViewController {
    
    weak var delegate: PlaylistsViewControllerDelegate?
    
    var items = [String]()
    
    var playlistDataStore = PlaylistsDataStore()
    
    var entryPop: EntryPopover!
    
    var dataSource = SearchControllerDataSource() {
        didSet {
            print("data source created")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entryPop = EntryPopover()
        title = "Playlists"
        entryPop.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseIdentifier)
        tableView.delegate = self
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-red").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(addPlaylist))
        rightButtonItem.tintColor = Colors.brightHighlight
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playlistDataStore.fetchFromCore()
    }
}
