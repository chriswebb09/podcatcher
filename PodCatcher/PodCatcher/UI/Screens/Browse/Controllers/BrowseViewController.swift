import UIKit

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
        }
        DispatchQueue.global(qos: .background).async {
            self.topItems = self.dataSource.items
            if self.dataSource.dataType == .local {
                self.dataSource.topStore.fetchFromCore()
                DispatchQueue.main.async {
                    self.view.bringSubview(toFront: self.collectionView)
                    self.topView.bringSubview(toFront: self.topCollectionView)
                    self.topCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
        UIView.animate(withDuration: 0.15) {
            self.view.alpha = 1
        }
    }
}
