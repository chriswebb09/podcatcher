import UIKit

class SearchViewController: BaseTableViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var dataSource = SearchControllerDataSource() {
        didSet {
            print("data source created")
        }
    }
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: tableView)
            case .collection:
                changeView(forView: tableView, withView: tableView)
                emptyView.removeFromSuperview()
            }
        }
    }
    
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
                showSearchBar()
                searchControllerConfigure()
            } else if !searchBarActive {
                if dataSource.items.count == 0 { viewShown = .empty }
                guard let nav = navigationController?.navigationBar else { return }
                tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: view.frame.height)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchBar = searchController.searchBar
        searchBarActive = true
        searchController.defaultConfiguration()
        tableView.delegate = self
        searchControllerConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.alpha = 1
        self.navigationController?.navigationBar.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBarActive = false
        searchController.isActive = false
    }
}
