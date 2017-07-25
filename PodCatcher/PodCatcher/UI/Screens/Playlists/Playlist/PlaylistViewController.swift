import UIKit
import CoreData

enum PlaylistMode {
    case player, list
}

protocol PlaylistViewControllerDelegate: class {
    func didSelectPodcast(at index: Int, with episodes: [PodcastPlaylistItem], caster: CasterSearchResult)
}

class PlaylistViewController: BaseCollectionViewController {
    
    var item: CasterSearchResult!
    var state: PodcasterControlState = .toCollection
    var player: AudioFilePlayer
    var dataSource: BaseMediaControllerDataSource!
    weak var delegate: PlaylistViewControllerDelegate?
    var playlistId: String
    var selectedSongIndex: Int!
    var episodes = [Episodes]()
    var mode: PlaylistMode = .list
    var caster = CasterSearchResult()
    var items = [PodcastPlaylistItem]()
    var bottomMenu = BottomMenu()
    var fetchedResultsController: NSFetchedResultsController<PodcastPlaylistItem>!
    let persistentContainer = NSPersistentContainer(name: "PodCatcher")
    var playlistTitle: String!
    let entryPop = EntryPopover()
    var topView = ListTopView()
    var feedUrl: String!
    
    init(index: Int, player: AudioFilePlayer) {
        self.playlistId = ""
        self.playlistTitle = ""
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        topView.delegate = self
        configureTopView()
        background.frame = view.frame
        view.addSubview(background)
        emptyView.alpha = 0
        edgesForExtendedLayout = []
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.sendSubview(toBack: background)
        collectionView.register(PodcastPlaylistCell.self)
        setupCoordinator()
//        player = AudioFilePlayer
//        player.delegate = self
//        player.observePlayTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        collectionView.alpha = 1
        navigationController?.navigationBar.topItem?.title = playlistTitle
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
    
    func moreButton(tapped: Bool) {
        let height = view.bounds.height * 0.5
        let width = view.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = view.bounds.width * 0.001
        let originY = view.bounds.height * 0.6
        let origin = CGPoint(x: originX, y: originY)
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
        showPopMenu()
    }
}
