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

// MARK: - UISearchController Delegate

extension SearchViewController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItems = []
        }
        if !searchBarActive {
            collectionView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func setupSearchController() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchBar.barTintColor = .white
    }
    
    func searchBarHasInput() {
        collectionView.reloadData()
        dataSource.items.removeAll()
        dataSource.store.searchForTracks { [weak self] playlist, error in
            guard let playlist = playlist, let strongSelf = self else { return }
            strongSelf.dataSource.items = playlist
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.performBatchUpdates ({
                DispatchQueue.main.async {
                    strongSelf.contentState = .results
                    strongSelf.collectionView.reloadItems(at: strongSelf.collectionView.indexPathsForVisibleItems)
                    strongSelf.collectionView.isHidden = false
                }
            }, completion: { finished in
                print(finished)
            })
        }
    }
    
    
    func searchOnTextChange(text: String, store: TrackDataStore, navController: UINavigationController) {
        dataSource.store.setSearch(term: text)
        searchBarActive = true
        if text != "" { searchBarHasInput() }
        navController.navigationBar.topItem?.title = "Search: \(text)"
        UIView.animate(withDuration: 1.8) {
            self.collectionView.alpha = 1
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text, let navcontroller = self.navigationController else { return }
        searchOnTextChange(text: barText, store: dataSource.store, navController: navcontroller)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString != nil {
            dataSource.items.removeAll()
            if let searchString = searchString {
                self.dataSource.store.setSearch(term: searchString)
                self.dataSource.store.searchForTracks { [weak self] tracks, error in
                    guard let strongSelf = self, let tracks = tracks else { return }
                    strongSelf.dataSource.items = tracks
                }
            }
        }
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource.items.removeAll()
        contentState = .none
        collectionView.reloadData()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        searchBarActive = false
    }
}
