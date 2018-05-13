import UIKit
import Reachability

final class BrowseViewController: BaseCollectionViewController, LoadingPresenting {
    
    static let headerId = "HeaderSection"
    
    weak var delegate: BrowseViewControllerDelegate?
    
    weak var coordinator: BrowseCoordinator?
   let browsePageController = BrowseTopCollectionViewController()
    var currentPlaylistId: String = ""
    var reach: Reachable?
    let browseTopView = BrowseTopView()

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
       // showLoadingView(loadingPop: loadingPop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var topView = UIView()
    
    var topItems: [Podcast] = [] {
        didSet {
            if collectionView.visibleCells.count <= 0 {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var cellModels: [TopPodcastCellViewModel] = []
    
    let concurrentPhotoQueue = DispatchQueue(label: "com.concurrent3.Queue", attributes: .concurrent)
    
    var featuredItems: [Podcast] = [] {
        didSet {
            DispatchQueue.main.async {
                self.browsePageController.topItems = self.featuredItems
                self.browsePageController.collectionView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    var added: [String] = []

    var gameTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
      //.  browsePageController.delegate = self
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        embedChild(controller: browsePageController, in: topView)

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
        collectionView.dataSource = self

        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        network.frame = view.frame
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .white
        //collectionView.prefetchDataSource = dataSource
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

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if featuredItems.count < 4 {
            return featuredItems.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(TopPodcastCell.self, indexPath: indexPath)
        let item = featuredItems[indexPath.row]
        if let url = URL(string: item.podcastArtUrlString) {
            DispatchQueue.main.async {
                UIImage.downloadImage(url: url) { image in
                    let topPodcatModel = TopPodcastCellViewModel(trackName: item.podcastTitle, podcastImage: image)
                    cell.configureCell(with: topPodcatModel, withTime: 0)
                }
            }
        }
        return cell
    }
    
    @objc func selectAt() {
        //coordinator?.didSelect(at: 0, with: dataSource.items[0], with: browseTopView.podcastImageView)
        topView.removeGestureRecognizer(tap)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        let cell = collectionView.cellForItem(at: indexPath) as! TopPodcastCell
        delegate?.selectedItem(at: indexPath.row, podcast: featuredItems[indexPath.row], imageView: cell.albumArtView)
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

public enum Pattern {
    case horizontalCenter
    case horizontalLeft
    case horizontalRight
}

struct BrowseCollectionDataSourceConstants {
    static let cellCount:Int = 4
}
