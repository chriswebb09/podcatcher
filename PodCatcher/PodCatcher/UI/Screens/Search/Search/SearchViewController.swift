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
                view.addSubview(emptyView)
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
                searchControllerConfigure()
                showSearchBar()
            } else if !searchBarActive {
                if dataSource.items.count == 0 { viewShown = .empty }
                guard let nav = navigationController?.navigationBar else { return }
                tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: nav.frame.maxY, width: UIScreen.main.bounds.width, height: view.frame.height)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchControllerConfigure()
        tableView.dataSource = dataSource
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchBar = searchController.searchBar
        searchBarActive = true
        searchController.defaultConfiguration()
        tableView.delegate = self
        searchControllerConfigure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dump(tableView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func hideSearchBar() {
        searchBar.removeFromSuperview()
        searchBarActive = false
    }
    
    
    func showSearchBar() {
        view.addSubview(searchBar)
        searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
        tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: view.frame.height - 60)
    }
    
    func searchControllerConfigure() {
        searchController.delegate = self
        searchBar = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            textFieldInsideSearchBar.backgroundColor = Colors.brightHighlight
            textFieldInsideSearchBar.clearButtonMode = .never
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
    }
}
