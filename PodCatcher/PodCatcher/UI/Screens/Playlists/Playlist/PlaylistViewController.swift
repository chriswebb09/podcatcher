import UIKit
import CoreData

class PlaylistViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    
    var dataSource: BaseMediaControllerDataSource!
    
    weak var delegate: PlaylistViewControllerDelegate?
    var playlistId: String
    var episodes = [Episodes]()
    
    var fetchedResultsController:NSFetchedResultsController<PodcastPlaylistItem>!
    
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
    let entryPop = EntryPopover()
    var topView = ListTopView()
    var feedUrl: String!
    
    init(index: Int) {
        self.playlistId = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        configureTopView()
        background.frame = view.frame
        view.addSubview(background)
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        collectionView.delegate = self
        collectionView.dataSource = self
        view.sendSubview(toBack: background)
        collectionView.register(PodcastResultCell.self)
        setupCoordinator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        collectionView.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        collectionView.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch state {
        case .toCollection:
            navigationController?.popViewController(animated: false)
        case .toPlayer:
            break
        }
    }
}

