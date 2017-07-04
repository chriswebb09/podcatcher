import UIKit

class HomeViewController: BaseCollectionViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    var bottomCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var dataSource: HomeCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var dataSourceTwo: HomeCollectionDataSourceTwo! {
        didSet {
            print("set")
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
        self.dataSourceTwo = HomeCollectionDataSourceTwo()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.alpha = 0
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(bottomCollectionView)
        bottomCollectionView.dataSource = dataSourceTwo
        collectionViewConfiguration()
        bottomCollectionView.setupBackground(frame: view.bounds)
        bottomCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        collectionView.register(TopPodcastCell.self)
        bottomCollectionView.register(TopPodcastCell.self)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.bottomCollectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
            self.view.bringSubview(toFront: self.bottomCollectionView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
            self.view.bringSubview(toFront: self.bottomCollectionView)
            self.bottomCollectionView.reloadData()
        }
    }
    
    func bottomViewConfiguration() {
        setup(view: view, newLayout: HomeItemsFlowLayout())
        
        bottomCollectionView.delegate = self
        // collectionView.dataSource = dataSource
        bottomCollectionView.isPagingEnabled = true
        bottomCollectionView.isScrollEnabled = true
        //  collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        //  collectionView.backgroundColor = .clear
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
        setupHome(with: newLayout)
        view.backgroundColor = .white
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        bottomCollectionView.frame = CGRect(x: 0, y: view.bounds.midY + 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        collectionView.backgroundColor = .white
        bottomCollectionView.backgroundColor = .clear
        bottomCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupHome(with newLayout: HomeItemsFlowLayout) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        bottomCollectionView.collectionViewLayout = newLayout
    }
}
