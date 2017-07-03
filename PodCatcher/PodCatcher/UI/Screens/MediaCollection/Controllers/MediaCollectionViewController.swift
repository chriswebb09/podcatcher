import UIKit

class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: MediaControllerDelegate?
    
    var dataSource: MediaCollectionDataSource
    var loadingPop = LoadingPopover()
    var backgroundView = UIView()
    
    // MARK: - UI Properties
    
    var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    let segmentControl = UISegmentedControl(items: ["Podcast", "Term"])
    
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            searchController.view.frame = CGRect.zero
        }
    }
    
    var searchBarActive: Bool = false {
        didSet {
            if searchBarActive {
                searchControllerConfigure()
                showSearchBar()
            } else if !searchBarActive {
                if dataSource.items.count == 0 { viewShown = .empty }
                guard let nav = navigationController?.navigationBar else { return }
                collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: nav.frame.maxY - 62, width: UIScreen.main.bounds.width, height: view.frame.height)
            }
        }
    }
    
    var viewShown: ShowView {
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
    
    init(dataSource: BaseMediaControllerDataSource) {
        let mediaDataSource = MediaCollectionDataSource()
        self.dataSource = mediaDataSource
        viewShown = self.dataSource.viewShown
        super.init(nibName: nil, bundle: nil)
        sideMenuPop = SideMenuPopover()
        searchController.defaultConfiguration()
        definesPresentationContext = false
        sideMenuPop.popView.delegate = self
        searchBar.delegate = self
        searchController.searchBar.delegate = self
        if dataSource.user != nil {
            leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button"), style: .done, target: self, action: #selector(search))
            rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
            navigationItem.setRightBarButton(rightButtonItem, animated: false)
            navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        }
        searchControllerConfigure()
        navigationBarSetup()
        searchBar.barTintColor = .white
        setupDefaultUI()
        emptyView.alpha = 0
        view.backgroundColor = Colors.brightHighlight
    }
    
    func showSearchBar() {
        viewShown = .collection
        view.addSubview(segmentControl)
        segmentControl.isHidden = false
        searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
        segmentControl.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: 44)
        segmentControl.addTarget(self, action: #selector(userSearch(segmentControl:)), for: .valueChanged)
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: segmentControl.frame.maxY + 5, width: UIScreen.main.bounds.width, height: view.frame.height - 88)
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
        collectionView.register(MediaCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "reusableHeaderView")
        searchController.searchBar.isHidden = false
        collectionViewConfiguration()
        title = "Podcasts"
        segmentControl.backgroundColor = .white
        collectionView.setupBackground(frame: view.bounds)
        collectionView.prefetchDataSource = self 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
        searchBarActive = false
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        //if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        searchBarActive = false
        hideSearchBar()
        segmentControl.isHidden = true
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.isHidden = true
        hideLoadingView(loadingPop: loadingPop)
    }
}
