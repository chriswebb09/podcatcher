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
        title = "Search"
        navigationController?.navigationBar.backgroundColor = .white
        edgesForExtendedLayout = [.bottom, .top, .left, .right, .all]
        searchController.delegate = self
        collectionView.register(TrackCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        buttonItem = UIBarButtonItem(image: dataSource.image, style: .plain, target: self, action: #selector(navigationBarSetup))
        buttonItem.tintColor = .mainColor
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupSearchController()
        CALayer.createGradientLayer(with: [UIColor.white.cgColor, UIColor.lightGray.cgColor],
                                    layer: view.layer,
                                    bounds: collectionView.bounds)
        collectionView.backgroundColor = .lightGray
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

extension SearchViewController: UICollectionViewDataSource {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    fileprivate func setTrackCell(indexPath: IndexPath, cell: TrackCell, rowTime: Double) {
        if let urlString = dataSource.items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString) {
            let cellViewModel = TrackCellViewModel(albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + rowTime) {
                UIView.animate(withDuration: rowTime) {
                    cell.alpha = 1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TrackCell
        cell.alpha = 0
        let rowTime = (Double(indexPath.row % 5)) / 8
        setTrackCell(indexPath: indexPath, cell: cell, rowTime: rowTime)
        return cell
    }
}
