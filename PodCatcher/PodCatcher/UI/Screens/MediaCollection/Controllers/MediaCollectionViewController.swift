import UIKit

class MediaCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    var buttonItem: UIBarButtonItem!
    
    weak var delegate: MediaControllerDelegate?
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var emptyView = EmptyView(frame: UIScreen.main.bounds)
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
            }
        }
    }
    
    var dataSource: BaseMediaControllerDataSource {
        didSet {
            if dataSource.casters.count > 0 {
                viewShown = .collection
            } else {
                viewShown = .empty
            }
        }
    }
    
    init(dataSource: BaseMediaControllerDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource) {
        self.init(dataSource: dataSource)
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        collectionViewConfiguration()
        title = "Podcasts"
        if dataSource.user != nil {
            buttonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logout))
            buttonItem.setTitleTextAttributes([
                NSFontAttributeName: UIFont(name:"Avenir", size: 16)!,
                NSForegroundColorAttributeName: PlayerViewConstants.titleViewBackgroundColor],
                                              for: .normal)
        }
        navigationItem.setRightBarButton(buttonItem, animated: false)
        collectionView.backgroundColor = .darkGray
        guard let frame = tabBarController?.tabBar.frame else { return }
        collectionView.frame = CGRect(x: view.bounds.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


