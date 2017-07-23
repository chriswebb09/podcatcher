import UIKit
import ReachabilitySwift

final class BrowseViewController: BaseCollectionViewController {
    
    weak var delegate: BrowseViewControllerDelegate?
    
    var currentPlaylistId: String = ""
    var topItems = [CasterSearchResult]()
    var topView = BrowseTopView()
    var tap: UITapGestureRecognizer!
    let loadingPop = LoadingPopover()
    let reachability = Reachability()!
    var network = NetworkConnectionView()
    
    var dataSource: HomeCollectionDataSource! {
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
        self.dataSource = HomeCollectionDataSource()
        super.init(nibName: nil, bundle: nil)
        showLoadingView(loadingPop: loadingPop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
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
            print("Network not reachable")
        } else {
            DispatchQueue.main.async {
                self.view.addSubview(self.network)
                self.view.bringSubview(toFront: self.network)
            }
            print("- Network not reachable")
        }
    }
}
