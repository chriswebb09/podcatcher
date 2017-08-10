import UIKit
import ReachabilitySwift

final class BrowseViewController: BaseCollectionViewController {
    
    weak var delegate: BrowseViewControllerDelegate?
    
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
    var network = InformationView(data: "CONNECT TO NETORK", icon: #imageLiteral(resourceName: "network-icon"))
    
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
        self.emptyView = InformationView(data: "No Data", icon: #imageLiteral(resourceName: "mic-icon"))
        emptyView.layoutSubviews()
        self.view.addSubview(self.network)
        self.view.sendSubview(toBack: self.network)
        network.layoutSubviews()
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight + 40)
        topView.frame = topFrame
        loadingPop.configureLoadingOpacity(alpha: 0.2)
        view.addSubview(topView)
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionViewConfiguration()
        network.frame = view.frame
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        collectionView.prefetchDataSource = dataSource
        tap = UITapGestureRecognizer(target: self, action: #selector(selectAt))
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "UICollectionReusableView", withReuseIdentifier: "SectionHeader")
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
        reach?.start()
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
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
//            guard let strongSelf = self else { return }
//            UIView.animate(withDuration: 0.2) {
//                strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
//            }
//        }
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
        delegate?.didSelect(at: 0, with: dataSource.items[0])
        topView.removeGestureRecognizer(tap)
    }
    
    func setup(view: UIView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY + 40, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 40)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.delegate?.didSelect(at: indexPath.row, with: self.dataSource.items[indexPath.row])
        }
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
