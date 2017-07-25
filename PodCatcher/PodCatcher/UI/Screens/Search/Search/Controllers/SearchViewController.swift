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
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        viewShown = dataSource.viewShown
        tableView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchBar = searchController.searchBar
        searchController.defaultConfiguration()
        tableView.delegate = self
        guard let tabbar = self.tabBarController?.tabBar else { return }
        searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
        tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: (view.frame.height - tabbar.frame.height) + 5)
        searchControllerConfigure()
        view.addSubview(searchBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.alpha = 1
        navigationController?.navigationBar.alpha = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Search"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.isActive = false
    }
    
    func searchControllerConfigure() {
        searchController.delegate = self
        searchBar = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchBar.tintColor = .black
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            textFieldInsideSearchBar.backgroundColor = Colors.brightHighlight
            textFieldInsideSearchBar.clearButtonMode = .never
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: textFieldInsideSearchBar.placeholder != nil ? textFieldInsideSearchBar.placeholder! : "", attributes: [NSForegroundColorAttributeName: UIColor.white])
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
    }
}
