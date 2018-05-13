import UIKit
import Reachability

final class BrowseViewController: BaseCollectionViewController, LoadingPresenting {
    
    static let headerId = "HeaderSection"
    
    weak var delegate: BrowseViewControllerDelegate?
    
    weak var coordinator: BrowseCoordinator?
    let browsePageController = BrowsePageController()
    var currentPlaylistId: String = ""
    var reach: Reachable?
    let browseTopView = BrowseTopView()
    
    var topItems: [PodcastItem] = [] {
        didSet {
            if collectionView.visibleCells.count <= 0 {
                DispatchQueue.main.async { [unowned self] in
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //    var topItems = [CasterSearchResult]() {
    //        didSet {
    //            topItems = dataSource.items
    //            if topItems.count > 0, let artUrl = topItems[0].podcastArtUrlString, let url = URL(string: artUrl) {
    //                browseTopView.podcastImageView.downloadImage(url: url)
    //                DispatchQueue.main.async {
    //                    self.browseTopView.setTitle(title: self.dataSource.items[self.browseTopView.index].podcastArtist!)
    //                    let mediaViewController = self.browsePageController.pages[0] as! MediaViewController
    //                    mediaViewController.topView.podcastImageView = self.browseTopView.podcastImageView
    //                    mediaViewController.topView.setTitle(title: self.dataSource.items[0].podcastTitle!)
    //                }
    //            }
    //
    //            if topItems.count > 1, let artUrl = topItems[1].podcastArtUrlString, let url = URL(string: artUrl) {
    //                self.browseTopView.setTitle(title: self.dataSource.items[self.browseTopView.index].podcastArtist!)
    //                let mediaViewController = self.browsePageController.pages[1] as! MediaViewController
    //                mediaViewController.topView.podcastImageView.downloadImage(url: url)
    //                mediaViewController.topView.setTitle(title: self.dataSource.items[1].podcastTitle!)
    //            }
    //        }
    //    }
    //
    var topView = UIView()
    var tap: UITapGestureRecognizer!
    let loadingPop = LoadingPopover()
    let reachability = Reachability()!
    var network = InformationView(data: "CANNOT CONNECT TO NETWORK", icon: #imageLiteral(resourceName: "network-icon"))
    let sectionHeader = BrowseSection()
    
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
    
    init(index: Int) {
        self.dataSource = BrowseCollectionDataSource()
        super.init(nibName: nil, bundle: nil)
        showLoadingView(loadingPop: loadingPop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        embedChild(controller: browsePageController, in: topView)
        let mediaViewController = browsePageController.pages[0] as! MediaViewController
        mediaViewController.topView.podcastImageView = self.browseTopView.podcastImageView
        
        emptyView = InformationView(data: "No Data", icon: #imageLiteral(resourceName: "mic-icon"))
        emptyView.layoutSubviews()
        view.addSubview(network)
        view.sendSubview(toBack: network)
        network.layoutSubviews()
        loadingPop.configureLoadingOpacity(alpha: 0.2)
        
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        view.addSubview(collectionView)
        let layout = BrowseItemsFlowLayout()
        layout.setup()
        setup(view: view, newLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        network.frame = view.frame
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .white
        collectionView.prefetchDataSource = dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityDidChangeNotificationName"), object: nil)
        reach?.start()
        DispatchQueue.main.async {
            self.browseTopView.podcastImageView.layer.cornerRadius = 3
            self.browseTopView.podcastImageView.layer.masksToBounds = true
            self.browseTopView.layer.setCellShadow(contentView: self.topView)
            self.browseTopView.podcastImageView.layer.setCellShadow(contentView: self.browseTopView.podcastImageView)
        }
        view.add(sectionHeader)
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        sectionHeader.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        sectionHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        sectionHeader.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        sectionHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: sectionHeader.bottomAnchor, constant: -15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        collectionView.isScrollEnabled = false
        view.layoutIfNeeded()
        sectionHeader.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
    }
    
    
    
    func setup(view: UIView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.layoutIfNeeded()
    }
    
    
    @objc func reachabilityDidChange(_ notification: Notification) {
        print("Reachability changed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tap = UITapGestureRecognizer(target: self, action: #selector(selectAt))
        browseTopView.podcastImageView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        UIView.animate(withDuration: 0.15) {
            self.view.alpha = 1
            
        }
        
        DispatchQueue.main.async { [weak self] in
            
            if let strongSelf = self {
                strongSelf.collectionView.reloadData()
            }
        }
    }
}

extension BrowseViewController: UICollectionViewDelegate {
    
    @objc func selectAt() {
        //coordinator?.didSelect(at: 0, with: dataSource.items[0], with: browseTopView.podcastImageView)
        topView.removeGestureRecognizer(tap)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        let cell = collectionView.cellForItem(at: indexPath) as! TopPodcastCell
        delegate?.selectedItem(at: indexPath.row, podcast: self.dataSource.items[indexPath.row], imageView: cell.albumArtView)
        //coordinator?.didSelect(at: indexPath.row, with: self.dataSource.items[indexPath.row], with: cell.albumArtView)
    }
}

extension BrowseViewController: UIScrollViewDelegate {
    
    @objc func reachabilityChanged(note: Notification) {
        if Reachable.isInternetAvailable() {
            DispatchQueue.main.async {
                self.view.sendSubview(toBack: self.network)
            }
        } else {
            DispatchQueue.main.async {
                self.view.bringSubview(toFront: self.network)
            }
        }
    }
}

