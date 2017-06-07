import UIKit

final class MediaCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    var buttonItem: UIBarButtonItem!
    weak var delegate: MediaControllerDelegate?
    var searchController = UISearchController(searchResultsController: nil)
    
    var searchBar = UISearchBar() {
        didSet {
            searchBar.delegate = self
            searchBar.returnKeyType = .done
        }
    }
    
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
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var emptyView = EmptyView()
    
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
        self.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(collectionView)
        collectionView.setupCollectionView(view: view, newLayout: TrackItemsFlowLayout())
        collectionView.collectionViewRegister(viewController: self)
    
        collectionView.delegate = self
        collectionView.dataSource = self
        title = "Podcasts"
        navigationController?.isNavigationBarHidden = false
        searchController.delegate = self
        buttonItem = UIBarButtonItem(image: dataSource.image, style: .plain, target: self, action: #selector(logout))
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupSearchController()
        collectionView.backgroundColor = .darkGray
        //collectionView.backgroundView?.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false 
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func changeView(forView: UIView, withView: UIView) {
        view.sendSubview(toBack: withView)
        view.bringSubview(toFront: forView)
    }
    
    func logout() {
        delegate?.logoutTapped(logout: true)
    }
}

extension MediaCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCaster(at: indexPath.row, with: dataSource.casters[indexPath.row])
    }
}

