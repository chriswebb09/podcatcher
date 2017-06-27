import UIKit

final class SearchViewController: BaseListViewController {
    
    var items = [PodcastSearchResult]()
    var segmentControl = UISegmentedControl()
    var buttonItem: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var searchBar = UISearchBar() {
        didSet {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        collectionView.register(TrackCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        buttonItem = UIBarButtonItem(image: dataSource.image, style: .plain, target: self, action: #selector(navigationBarSetup))
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupSearchController()
        CALayer.createGradientLayer(with: [UIColor.gray.cgColor, UIColor.darkGray.cgColor],
                                    layer: view.layer,
                                    bounds: collectionView.bounds)
        collectionView.backgroundColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    func setupNavigationBar(navController: UINavigationController, searchController: UISearchController) {
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar = searchController.searchBar
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        setupNavigationBar(navController: navController, searchController: searchController)
        searchBar.becomeFirstResponder()
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
}

