import UIKit
import ReachabilitySwift

final class BrowseViewController: BaseCollectionViewController, LoadingPresenting {
    
    weak var delegate: BrowseViewControllerDelegate?
    weak var coordinator: BrowseCoordinator?
    var currentPlaylistId: String = ""
    var reach: Reachable?
    
    var topItems = [CasterSearchResult]() {
        didSet {
            topItems = dataSource.items
            if topItems.count > 0, let artUrl = topItems[0].podcastArtUrlString, let url = URL(string: artUrl) {
                topView.podcastImageView.downloadImage(url: url)
            }
        }
    }
    
    var topView = BrowseTopView()
    var tap: UITapGestureRecognizer!
    let loadingPop = LoadingPopover()
    let reachability = Reachability()!
    var network = InformationView(data: "CANNOT CONNECT TO NETWORK", icon: #imageLiteral(resourceName: "network-icon"))
    
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
        coordinator?.viewDidLoad(self)
        tap = UITapGestureRecognizer(target: self, action: #selector(selectAt))
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
        reach?.start()
    }
    
    
    func setup(view: UIView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY + 100, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 100)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func reachabilityDidChange(_ notification: Notification) {
        print("Reachability changed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
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
        if Reachable.isInternetAvailable() {
            DispatchQueue.main.async {
                self.view.sendSubview(toBack: self.network)
            }
        }
        print("INTERNET IS REACHABLE \(Reachable.isInternetAvailable())")
    }
}

extension BrowseViewController: UICollectionViewDelegate {
    
    @objc func selectAt() {
        coordinator?.didSelect(at: 0, with: dataSource.items[0])
        topView.removeGestureRecognizer(tap)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        coordinator?.didSelect(at: indexPath.row, with: self.dataSource.items[indexPath.row])
    }
}

extension BrowseViewController: UIScrollViewDelegate {
    
    @objc func reachabilityChanged(note: Notification) {
        if reachability.isReachable {
            print("browse is reachable")
        } else {
            DispatchQueue.main.async {
                self.view.bringSubview(toFront: self.network)
            }
        }
    }
}
