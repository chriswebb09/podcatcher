import UIKit

protocol BrowseViewControllerDelegate: class {
    func didSelect(at index: Int)
    func didSelect(at index: Int, with cast: PodcastSearchResult)
    func logout(tapped: Bool)
}

final class BrowseViewController: BaseCollectionViewController {
    
    weak var delegate: BrowseViewControllerDelegate?
    
    lazy var topCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var currentPlaylistId: String = ""
    var topItems = [CasterSearchResult]()
    var topView = BrowseTopView()
    var dataSource: HomeCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                view.addSubview(emptyView)
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
                emptyView.removeFromSuperview()
            }
        }
    }
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        self.dataSource = HomeCollectionDataSource()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight)
        topView.frame = topFrame
        view.addSubview(topView)
        view.backgroundColor = .clear
        topView.backgroundColor = .clear
        topCollectionView.backgroundColor = .red
        topCollectionView.dataSource = self
        topCollectionView.register(TopPodcastCell.self)
        view.addSubview(collectionView)
        collectionViewConfiguration()
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        topView.addSubview(topCollectionView)
        setupBottom()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.topCollectionView.reloadData()
            self.topItems = self.dataSource.items
            self.view.bringSubview(toFront: self.collectionView)
            self.topView.bringSubview(toFront: self.topCollectionView)
            if self.dataSource.dataType == .local {
                self.dataSource.topStore.fetchFromCore()
                self.topCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
       // navigationItem.prompt = "Browse Top Podcasts"
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
        }
    }
}


extension BrowseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = topCollectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        if let imagurl = topItems[indexPath.row].podcastArtUrlString, let url = URL(string: imagurl) {
            cell.albumArtView.downloadImage(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    func setupBottom() {
        topCollectionView.delegate = self
        topCollectionView.isPagingEnabled = true
        topCollectionView.isScrollEnabled = true
        topCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}

extension BrowseViewController: UICollectionViewDelegate {
    
    func setup(view: UIView, newLayout: BrowseItemsFlowLayout) {
        newLayout.setup()
        setupHome(with: newLayout)
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupHome(with newLayout: BrowseItemsFlowLayout) {
        collectionView.collectionViewLayout = newLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
