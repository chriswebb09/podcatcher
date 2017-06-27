import UIKit

final class SearchViewController: BaseCollectionViewController {
    
    var sideMenuPop = SideMenuPopover()
    var items = [PodcastSearchResult]()
    var searchBarBoundsY: CGFloat!
    
    var segmentControl = UISegmentedControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    var gradLayer: CAGradientLayer!
    
    var searchBarActive: Bool = false {
        didSet {
            if searchBarActive {
                guard let navController = self.navigationController else { return }
                searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
                collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: view.frame.height)
            }
        }
    }
    
    var dataSource: ListControllerDataSource
    
    weak var delegate: SearchViewControllerDelegate?
    
    init(dataSource: ListControllerDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultUI()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionView(collectionView: collectionView, view: view, newLayout: TrackItemsFlowLayout())
        gradLayer = CALayer.buildGradientLayer(with: [UIColor.white.cgColor, UIColor.lightGray.cgColor],
                                               layer: view.layer,
                                               bounds: collectionView.bounds)
        view.layer.addSublayer(gradLayer)
        navigationController?.navigationBar.backgroundColor = .white
        edgesForExtendedLayout = []
        searchController.delegate = self
        collectionView.register(TrackCell.self)
        navigationBarSetup()
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchBar.delegate = self
        definesPresentationContext = false
        collectionView.backgroundColor = .lightGray
        gradLayer.isHidden = true
        var tap = UITapGestureRecognizer(target: self, action: #selector(emptyViewShower))
        emptyView.addGestureRecognizer(tap)
        //view.sendSubview(toBack: emptyView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.isHidden = false
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.isHidden = true
    }
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        searchBar = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: navController.navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: 0)
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        view.addSubview(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setSearchBarActive() {
        self.searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
    }
    
    func showMenu() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        view.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(hideMenu))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
        UIView.animate(withDuration: 0.15) {
            self.sideMenuPop.showPopView(viewController: self)
            self.sideMenuPop.popView.isHidden = false
        }
    }
    
    func popBottomMenu(popped: Bool) {
        sideMenuPop.setupPop()
        showMenu()
    }
    
    func hideMenu() {
        sideMenuPop.hideMenu(controller: self)
        rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
        navigationItem.setRightBarButton(rightButtonItem, animated: false)
    }
    
    func emptyViewShower() {
        setSearchBarActive()
        willPresentSearchController(searchController)
        view.bringSubview(toFront: collectionView)
        dump(collectionView.delegate)
    }
}

