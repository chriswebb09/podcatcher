import UIKit

class HomeViewController: BaseCollectionViewController {
    
    var scrollView: UIScrollView?
    
    weak var delegate: HomeViewControllerDelegate?
    
    var dataSource: HomeCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }

    var topView = ListTopView()
    
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
        emptyView.alpha = 0
        title = "PodCatch"
        let topFrameHeight = UIScreen.main.bounds.height / 2
        let topFrameWidth = UIScreen.main.bounds.width
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight / 1.2)
        topView.frame = topFrame
        view.addSubview(topView)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionViewConfiguration()
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
        }
    }
    
    func collectionViewConfiguration() {
        setup(view: view, newLayout: HomeItemsFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func setup(view: UIView, newLayout: HomeItemsFlowLayout) {
        newLayout.setup()
        setupHome(with: newLayout)
        collectionView.frame = CGRect(x: 0, y: view.bounds.midY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupHome(with newLayout: HomeItemsFlowLayout) {
        collectionView.collectionViewLayout = newLayout
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
}
