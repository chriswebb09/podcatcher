import UIKit
import CoreData

class PlaylistViewController: BaseCollectionViewController, NSFetchedResultsControllerDelegate {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    
    var dataSource: BaseMediaControllerDataSource!
    
    weak var delegate: PlaylistViewControllerDelegate?
    var playlistId: String
    var episodes = [Episodes]()
    
    var fetchedResultsController:NSFetchedResultsController<PodcastPlaylistItem>!
    
    private let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    
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
        setupPersistentStore()
    }
    
    
    func setupPersistentStore() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
}

