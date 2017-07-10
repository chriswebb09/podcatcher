import UIKit

final class HomeViewController: BaseCollectionViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    lazy var topCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var currentPlaylistId: String = ""
    var topItems = [CasterSearchResult]()
    var topView = HomeTopView()
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
        title = "PodCatch"
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
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
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
