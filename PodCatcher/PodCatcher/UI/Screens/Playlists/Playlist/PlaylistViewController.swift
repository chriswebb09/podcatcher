import UIKit
import CoreData

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
    var playlistDataSource: CollectionViewDataSource<PlaylistViewController>!
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
        // collectionView.dataSource = self
        view.sendSubview(toBack: background)
        collectionView.register(PodcastPlaylistCell.self)
        setupCoordinator()
        collectionView.dataSource = playlistDataSource
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

extension PlaylistViewController: NSFetchedResultsControllerDelegate {
    
    func setupCoordinator() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("Unable to Load Persistent Store - \(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let fetchError {
                    print("Unable to Perform Fetch Request - \(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - PodcastCollectionViewProtocol

extension PlaylistViewController {
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(PodcastCell.self)
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
    
    func configureTopView() {
        topView.frame = PodcastListConstants.topFrame
        if let item = item, let urlString = item.podcastArtUrlString, let url = URL(string: urlString) {
            topView.podcastImageView.downloadImage(url: url)
        } else {
            topView.podcastImageView.image = #imageLiteral(resourceName: "light-placehoder-2")
        }
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
        setupView()
    }
}

extension PlaylistViewController {
    
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest:NSFetchRequest<PodcastPlaylistItem> = PodcastPlaylistItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playlistId", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "playlistId == %@", playlistId)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let navHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = (view.bounds.height - navHeight) - 55
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 10), width: view.bounds.width, height: viewHeight - (topView.frame.height - tabBar.frame.height))
        collectionView.backgroundColor = .clear
    }
}

// MARK: - UIScrollViewDelegate

extension PlaylistViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let updatedTopViewFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
        if offset.y > PodcastListConstants.minimumOffset {
            UIView.animate(withDuration: 0.05) {
                self.topView.removeFromSuperview()
                self.topView.alpha = 0
                self.collectionView.frame = self.view.bounds
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                guard let tabBar = self.tabBarController?.tabBar else { return }
                guard let navHeight = self.navigationController?.navigationBar.frame.height else { return }
                let viewHeight = (self.view.bounds.height - navHeight) - 20
                self.topView.frame = updatedTopViewFrame
                self.topView.alpha = 1
                self.topView.layoutSubviews()
                self.view.addSubview(self.topView)
                self.collectionView.frame = CGRect(x: self.topView.bounds.minX, y: self.topView.frame.maxY, width: self.view.bounds.width, height: viewHeight - (self.topView.frame.height - tabBar.frame.height))
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        guard let artData = item.artwork as? Data else { return }
        let artImage = UIImage(data: artData)
        topView.podcastImageView.image = artImage
        if let index = selectedSongIndex {
            let playerIndexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: playerIndexPath) as! PodcastPlaylistCell
            if indexPath.row != index {
                cell.switchAlpha(hidden: true)
                player.playPause()
            } else if indexPath.row == index {
                let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
                cell.switchAlpha(hidden: true)
            }
        }
        let cell = collectionView.cellForItem(at: indexPath) as! PodcastPlaylistCell
        cell.switchAlpha(hidden: false)
        selectedSongIndex = indexPath.row
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 1.01, height: UIScreen.main.bounds.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension PlaylistViewController: TopViewDelegate {
    
    func entryPop(popped: Bool) {
        print("popped: \(popped)")
    }
    
    func popBottomMenu(popped: Bool) {
        showPopMenu()
    }
    
    func showPopMenu() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopMenu))
        view.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
        topView.addGestureRecognizer(tap)
        bottomMenu.showOn(collectionView)
    }
    
    @objc func hidePopMenu() {
        print("hidePopMenu")
    }
}

extension PlaylistViewController: AudioFilePlayerDelegate {
    
    func trackFinishedPlaying() {
        print("finished")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        print(stringTime)
    }
    
    func updateProgress(progress: Double) {
        print(progress)
    }
}

extension PlaylistViewController: CollectionViewDataSourceDelegate {
    typealias Object = PodcastPlaylistItem
    
    typealias Cell = PodcastPlaylistCell
    
    func configure(_ cell: PodcastPlaylistCell, for object: PodcastPlaylistItem) {
        if let title = object.episodeTitle, let artist = object.artistName {
            let modelName = "\(title)  -  \(artist)"
            let model = PodcastCellViewModel(podcastTitle: modelName)
            cell.configureCell(model: model)
        }
    }
}
