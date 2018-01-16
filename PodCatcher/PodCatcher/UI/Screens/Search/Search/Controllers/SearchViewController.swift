import UIKit
import ReachabilitySwift

final class SearchViewController: BaseTableViewController, LoadingPresenting {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var dataSource = SearchControllerDataSource() {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    let infoLabel = UILabel.setupInfoLabel(infoText: "Searching...")
    
    var viewShown: ShowView! {
        didSet {
            guard let viewShown = viewShown else { return }
            switch viewShown {
            case .empty:
                infoLabel.text = "Search for podcasts"
            case .collection:
                print("collection")
            }
        }
    }
    
    let loadingPop = LoadingPopover()
    
    var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
        tableView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        let background = UIView()
        background.frame = view.frame
        tableView.backgroundView = background
        background.addSubview(infoLabel)
        
        viewShown = dataSource.viewShown
        guard let navBar = navigationController?.navigationBar, let tabbar = self.tabBarController?.tabBar else { return }
        
        searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: navBar.frame.height / 2)
        
        let height = (view.frame.height - tabbar.frame.height)
        if #available(iOS 11.0, *) {
            searchBar.insetsLayoutMarginsFromSafeArea = true
        } else {
            // Fallback on earlier versions
        }
        tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: navBar.frame.height + searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: height)
        searchControllerConfigure()
        searchController.defaultConfiguration()
        view.addSubview(searchBar)
        searchBar.layoutIfNeeded()
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        infoLabel.sizeToFit()
        infoLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
        infoLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
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
        searchBar.barTintColor = .white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
        searchBar.backgroundColor = .white
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            textFieldInsideSearchBar.clearButtonMode = .never
            textFieldInsideSearchBar.font = UIFont(name: "AvenirNext-Regular", size: 16)
            let attributes = [
                NSAttributedStringKey.font : UIFont(name: "AvenirNext-Regular", size: 16)
            ]
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel "
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: textFieldInsideSearchBar.placeholder != nil ? textFieldInsideSearchBar.placeholder! : " ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
            
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .black
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        searchController.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResultsForSearchController(searchController: searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString != nil {
            
            if let searchString = searchString, searchString != "" {
                
                self.dataSource.interactor.setSearch(term: searchString)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setSearch), object: nil)
                self.perform(#selector(setSearch), with: nil, afterDelay: 0.025)
            }
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
    @objc func setSearch() {
        infoLabel.isHidden = false
        dataSource.interactor.searchForTracks { [weak self] playlist, error in
            if let error = error {
                DispatchQueue.main.async {
                    
                    let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    
                    let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
                        actionSheetController.dismiss(animated: false, completion: nil)
                    }
                    
                    actionSheetController.addAction(okayAction)
                    
                    self?.present(actionSheetController, animated: false)
                }
                self?.infoLabel.isHidden = true
                return
            }
            guard let playlist = playlist, let strongSelf = self else { return }
            
            strongSelf.dataSource.items = playlist
            self?.infoLabel.isHidden = true
            
            DispatchQueue.main.async {
                
                strongSelf.tableView.reloadData()
                strongSelf.tableView.reloadRows(at: strongSelf.tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
                
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchOnTextChange(text: String, navController: UINavigationController) {
        if text == "" {
            dataSource.items.removeAll()
            navController.navigationBar.topItem?.title = "Search"
            tableView.reloadData()
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
            return
        } else if text != "" {
            dataSource.interactor.setSearch(term: text)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setSearch), object: nil)
            self.perform(#selector(setSearch), with: nil, afterDelay: 0.35)
            navController.navigationBar.topItem?.title = "Search: \(text)"
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text, let navcontroller = self.navigationController else { return }
        searchOnTextChange(text: barText, navController: navcontroller)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                if strongSelf.dataSource.items.count > 0 {
                    
                    strongSelf.searchController.isActive = false
                    strongSelf.delegate?.didSelect(at: indexPath.row, with: strongSelf.dataSource.items[indexPath.row])
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
                
                let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
                    tableView.isUserInteractionEnabled = true
                    actionSheetController.dismiss(animated: false, completion: nil)
                }
                
                actionSheetController.addAction(okayAction)
                strongSelf.present(actionSheetController, animated: false)
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchController.isActive = false
        title = "Search"
    }
}

extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 75 ||  scrollView.contentOffset.y < -75 {
            view.endEditing(true)
            searchBar.resignFirstResponder()
        }
    }
}
