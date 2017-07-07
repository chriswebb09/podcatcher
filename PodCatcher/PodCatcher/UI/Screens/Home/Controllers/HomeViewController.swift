import UIKit

final class HomeViewController: BaseCollectionViewController {
    
    var scrollView: UIScrollView
    
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
        self.scrollView = UIScrollView(frame: CGRect.zero)
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
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight)
        
        topView.frame = topFrame
        view.addSubview(topView)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        topView.addSubview(scrollView)
        
        scrollView.frame = topFrame
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionViewConfiguration()
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
             if self.dataSource.dataType == .local {
                self.dataSource.topStore.fetchFromCore()
                self.topView.podcastImageView.image = self.dataSource.topItemImage
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
