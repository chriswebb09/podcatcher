import UIKit

final class SearchViewController: BaseCollectionViewController {
   
    var items = [PodcastSearchResult]()
    var searchBarBoundsY: CGFloat!
    
    var segmentControl = UISegmentedControl()
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            searchController.view.frame = CGRect.zero
        }
    }
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
        title = "PodCatcher"
        searchController.delegate = self
        collectionView.register(TrackCell.self)
        navigationBarSetup()
        if dataSource.user != nil {
            leftButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logout))
            leftButtonItem.setTitleTextAttributes(MediaCollectionConstants.stringAttributes, for: .normal)
            rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-red"), style: .done, target: self, action: #selector(popBottomMenu(popped:)))
            navigationItem.setRightBarButton(rightButtonItem, animated: false)
            navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        }
        searchControllerConfigure()
        searchBar.delegate = self
        definesPresentationContext = false
        collectionView.backgroundColor = .lightGray
        gradLayer.isHidden = true
        var tap = UITapGestureRecognizer(target: self, action: #selector(emptyViewShower))
        emptyView.addGestureRecognizer(tap)
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
    
    func searchControllerConfigure() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    func logout() {
        delegate?.logout(tapped: true)
    }
}
