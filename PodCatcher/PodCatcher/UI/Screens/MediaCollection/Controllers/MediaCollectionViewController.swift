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

extension MediaCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewShown = .collection
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let artWork = dataSource.casters[indexPath.row].artwork, let name = dataSource.casters[indexPath.row].name {
            let model = MediaCellViewModel(trackName: name, albumImageURL: artWork)
            cell.configureCell(with: model, withTime: 0)
            print(indexPath.row)
            cell.alpha = 1
        }
       
        return cell
    }
}

// MARK: - UISearchControllerDelegate

extension MediaCollectionViewController: UISearchControllerDelegate {
    
    func setupSearchController() {
        setSearchBarColor(searchBar: searchBar)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchBar.barTintColor = .white
    }
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        setupNavigationBar(navController: navController, searchController: searchController)
        searchBar.becomeFirstResponder()
    }
    
    func setupNavigationBar(navController: UINavigationController, searchController: UISearchController) {
        navController.navigationBar.barTintColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar = searchController.searchBar
        searchBar.barTintColor = .darkGray
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .darkGray
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }
}

// MARK: - UISearchBarDelegate

extension MediaCollectionViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarActive = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setSearchBarActive() {
        self.searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
    }
    
    func searchBarHasInput() {
        collectionView.reloadData()
    }
    
    func searchOnTextChange(text: String, store: MediaDataStore, navController: UINavigationController) {
        searchBarActive = true
        if text != "" { searchBarHasInput() }
        navController.navigationBar.topItem?.title = "Search: \(text)"
        UIView.animate(withDuration: 1.8) {
            self.collectionView.alpha = 1
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItems = []
        }
        if !searchBarActive { collectionView.reloadData() }
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
    }
    
    func onCancel(collectionView: UICollectionView, dataSource: BaseMediaControllerDataSource, store: MediaDataStore) {
        collectionView.reloadData()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        searchBarActive = false
        viewShown = .empty
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}

// MARK: - UISearchResultsUpdating

extension MediaCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
       
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
    }
}
