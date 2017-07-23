import UIKit

class SearchViewController: BaseTableViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var dataSource = SearchControllerDataSource() {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var viewShown: ShowView! {
        didSet {
            guard let viewShown = viewShown else { return }
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: tableView)
            case .collection:
                changeView(forView: tableView, withView: emptyView)
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
                guard let tabbar = self.tabBarController?.tabBar else { return }
                tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: (view.frame.height - tabbar.frame.height) + 5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        viewShown = dataSource.viewShown
        tableView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0)
        searchControllerConfigure()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchBar = searchController.searchBar
        searchBarActive = true
        searchController.defaultConfiguration()
        tableView.delegate = self
        searchControllerConfigure()
        view.addSubview(searchBar)
        title = "Search"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.alpha = 1
        self.navigationController?.navigationBar.alpha = 1
        emptyView.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBarActive = false
        searchController.isActive = false
    }
}
