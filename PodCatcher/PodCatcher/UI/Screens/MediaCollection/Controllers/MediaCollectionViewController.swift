import UIKit

final class MediaCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    var buttonItem: UIBarButtonItem!
    weak var delegate: MediaControllerDelegate?
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var emptyView = EmptyView()
    
    var searchBarActive: Bool = false {
        didSet {
            if searchBarActive == true {
                navigationItem.rightBarButtonItems = []
            } else {
                if let buttonItem = buttonItem {
                    navigationItem.rightBarButtonItems = [buttonItem]
                }
            }
        }
    }
    
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
    
    convenience init(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource, searchController: UISearchController) {
        self.init(dataSource: dataSource)
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(collectionView)
        collectionView.setupCollectionView(view: view, newLayout: TrackItemsFlowLayout())
        collectionView.collectionViewRegister(viewController: self)
        collectionView.delegate = self
        collectionView.dataSource = self
        title = dataSource.user?.username
        navigationController?.isNavigationBarHidden = false
        buttonItem = UIBarButtonItem(image: dataSource.image, style: .plain, target: self, action: #selector(logout))
        navigationItem.setRightBarButton(buttonItem, animated: false)
        collectionView.backgroundColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false 
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func changeView(forView: UIView, withView: UIView) {
        view.sendSubview(toBack: withView)
        view.bringSubview(toFront: forView)
    }
    
    func logout() {
        if dataSource.user != nil {
            dataSource.user = nil
        }
        delegate?.logoutTapped(logout: true)
    }
}


