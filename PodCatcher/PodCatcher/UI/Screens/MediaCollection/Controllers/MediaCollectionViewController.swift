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
                viewShown = .collection
                view.addSubview(segmentControl)
                searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
                segmentControl.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: 44)
                segmentControl.addTarget(self, action: #selector(userSearch(segmentControl:)), for: .valueChanged)
                collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: segmentControl.frame.maxY + 5, width: UIScreen.main.bounds.width, height: view.frame.height - 88)
            }
        }
    }
    
    var viewShown: ShowView {
        didSet {
            switch viewShown {
            case .empty:
                view.addSubview(emptyView)
                changeView(forView: emptyView, withView: collectionView)
            //  emptyView.alpha = 1
            case .collection:
                
                changeView(forView: collectionView, withView: emptyView)
                emptyView.removeFromSuperview()
                //    emptyView.alpha = 0
            }
        }
    }
    
    init(dataSource: BaseMediaControllerDataSource) {
        let mediaDataSource = MediaCollectionDataSource()
        self.dataSource = mediaDataSource
        self.viewShown = self.dataSource.viewShown
        
        super.init(nibName: nil, bundle: nil)
        sideMenuPop = SideMenuPopover()
        let grad = CALayer.buildGradientLayer(with: [UIColor.offMain.cgColor, UIColor.mainColor.cgColor, UIColor.semiOffMain.cgColor], layer: CALayer(), bounds: view.bounds)
        
        view.layer.insertSublayer(grad, at: 0)
        searchController.defaultConfiguration()
        searchControllerConfigure()
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
        collectionView.register(MediaCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "reusableHeaderView")
        searchController.searchBar.isHidden = false
        collectionViewConfiguration()
        title = "Podcasts"
        collectionView.setupBackground(frame: view.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.isHidden = true
        hideLoadingView(loadingPop: loadingPop)
    }
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        collectionView.dataSource = self
        collectionView.register(TrackCell.self)
        collectionView.delegate = self
        searchController.searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: navController.navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: 0)
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        view.addSubview(searchBar)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.leftView?.alpha = 0
        searchBar.alpha = 0.7
    }
    
    func popBottomMenu(popped: Bool) {
        hideSearchBar()
        sideMenuPop.setupPop()
        showMenu()
    }
    
    func search() {
        searchBarActive = true
        self.willPresentSearchController(searchController)
    }
    
    func searchControllerConfigure() {
        searchController.delegate = self
        searchBar = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            textFieldInsideSearchBar.backgroundColor = .mainColor
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
    }
    
    func userSearch(segmentControl: UISegmentedControl){
        switch segmentControl.selectedSegmentIndex{
        case 0:
            print(0)
        case 1:
            print(1)
        case 2:
            print(3)
        default:
            break
        }
        
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
