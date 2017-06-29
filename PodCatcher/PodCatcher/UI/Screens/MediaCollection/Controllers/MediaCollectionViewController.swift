import UIKit

class MediaCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    weak var delegate: MediaControllerDelegate?
    var dataSource: MediaCollectionDataSource
    
    // MARK: - UI Properties
    
    var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            searchController.view.frame = CGRect.zero
        }
    }
    
    var searchBarActive: Bool = false {
        didSet {
            if searchBarActive {
                guard let navController = self.navigationController else { return }
                searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
                collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: view.frame.height)
            }
        }
    }

    
    var viewShown: ShowView {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
            }
        }
    }
    
    init(dataSource: BaseMediaControllerDataSource) {
        let mediaDataSource = MediaCollectionDataSource()
        self.dataSource = mediaDataSource
        self.viewShown = self.dataSource.viewShown
        
        super.init(nibName: nil, bundle: nil)
        sideMenuPop = SideMenuPopover()
      
        definesPresentationContext = false
        sideMenuPop.popView.delegate = self
        searchController.delegate = self
        searchBar = searchController.searchBar
        searchBar.delegate = self
        searchController.searchBar.delegate = self 
        if dataSource.user != nil {
            leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button"), style: .done, target: self, action: #selector(search))
            rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
            navigationItem.setRightBarButton(rightButtonItem, animated: false)
            navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        navigationBarSetup()
        setupDefaultUI()
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
        collectionViewConfiguration()
        title = "Podcasts"
        collectionView.setupBackground(frame: view.bounds)
    }
    
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        searchBar = searchController.searchBar
        collectionView.dataSource = self
        searchControllerConfigure()
        collectionView.register(TrackCell.self)
        collectionView.delegate = self
        searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: navController.navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: 0)
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        view.addSubview(searchBar)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.leftView?.alpha = 0
        searchBar.alpha = 0.7
    }
    
    func popBottomMenu(popped: Bool) {
        sideMenuPop.setupPop()
        showMenu()
    }
    
    func search() {
        searchBarActive = true
        self.willPresentSearchController(searchController)
    }
    

    func searchControllerConfigure() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension MediaCollectionViewController: SideMenuDelegate {
    
    func optionOne(tapped: Bool) {
        print("one")
        delegate?.logout(tapped: true)
    }  
    
    func optionTwo(tapped: Bool) {
        
    }
    
    func optionThree(tapped: Bool) {
        print("nee")
    }
}
