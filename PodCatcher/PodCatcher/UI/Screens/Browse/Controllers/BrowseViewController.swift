import UIKit
import ReachabilitySwift
import CoreData

final class TopPodcastsDataStore {
    
    var podcasts: [NSManagedObject] = []
    
    func fetchFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TopPodcast")
        do {
            podcasts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

protocol BrowseViewControllerDelegate: class {
    func didSelect(at index: Int)
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func logout(tapped: Bool)
}

final class BrowseItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2.8)
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
        minimumLineSpacing = 30
    }
}

final class BrowseViewController: BaseCollectionViewController {
    
    weak var delegate: BrowseViewControllerDelegate?
    
    var currentPlaylistId: String = ""
    var topItems = [CasterSearchResult]()
    var topView = BrowseTopView()
    var tap: UITapGestureRecognizer!
    let loadingPop = LoadingPopover()
    let reachability = Reachability()!
    var network = NetworkConnectionView()
    
    var dataSource: BrowseCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                print("empty")
            case .collection:
                print("collection")
            }
        }
    }
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        self.dataSource = BrowseCollectionDataSource()
        super.init(nibName: nil, bundle: nil)
        showLoadingView(loadingPop: loadingPop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight + 40)
        topView.frame = topFrame
        
        view.addSubview(topView)
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionViewConfiguration()
        
        network.frame = view.frame
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        tap = UITapGestureRecognizer(target: self, action: #selector(selectAt))
        topItems = dataSource.items
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.view.bringSubview(toFront: strongSelf.collectionView)
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        topView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.15) {
            self.view.alpha = 1
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                UIView.animate(withDuration: 0.6) {
                    strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
                }
            }
        }
    }
    
    func selectAt() {
        switch dataSource.dataType {
        case .local:
            delegate?.didSelect(at: 0)
            topView.removeGestureRecognizer(tap)
        case .network:
            delegate?.didSelect(at: 0, with: dataSource.items[0])
            topView.removeGestureRecognizer(tap)
        }
    }
    
    func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else { return }
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else if (reachability.whenUnreachable != nil) {
            view.addSubview(network)
            view.bringSubview(toFront: network)
        } else {
            DispatchQueue.main.async {
                self.view.addSubview(self.network)
                self.view.bringSubview(toFront: self.network)
            }
        }
    }
}

extension BrowseViewController: UICollectionViewDelegate {
    
    func setup(view: UIView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        setupHome(with: newLayout)
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY + 40, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 40)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupHome(with newLayout: BrowseItemsFlowLayout) {
        collectionView.collectionViewLayout = newLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        switch dataSource.dataType {
        case .local:
            delegate?.didSelect(at: indexPath.row)
        case .network:
            delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
        }
    }
    
    func logoutTapped() {
        delegate?.logout(tapped: true)
    }
}

extension BrowseViewController: UIScrollViewDelegate {
    
    func collectionViewConfiguration() {
        setup(view: view, newLayout: BrowseItemsFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
}
