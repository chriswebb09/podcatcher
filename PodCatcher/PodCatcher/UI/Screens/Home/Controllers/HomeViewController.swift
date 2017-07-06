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
        let topFrame = CGRect(x: 0, y: 0, width: topFrameWidth, height: topFrameHeight / 1.2)
        
        topView.frame = topFrame
        view.addSubview(topView)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        topView.addSubview(scrollView)
        scrollView.frame = topFrame
        
        leftButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutTapped))
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        
        collectionViewConfiguration()
        collectionView.register(TopPodcastCell.self)
        collectionView.backgroundColor = .darkGray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.topStore.fetchFromCore()
        if dataSource.dataType == .local {
            DispatchQueue.main.async {
                self.topView.podcastImageView.image = self.dataSource.topItemImage
            }
            
        }
    }
}
