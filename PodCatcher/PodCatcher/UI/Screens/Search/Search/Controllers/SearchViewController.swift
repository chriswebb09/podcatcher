import UIKit
import Reachability

final class SearchViewController: BaseViewController, LoadingPresenting {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    weak var delegate: SearchViewControllerDelegate?
    
    var playerContainer: UIView = UIView()
    
    var dataSource = SearchControllerDataSource() {
        didSet {
            // viewShown = dataSource.viewShown
        }
    }
    
    var headerView = UIView()
    
    let infoLabel = UILabel.setupInfoLabel()
    
    //    var viewShown: ShowView! {
    //        didSet {
    //            guard let viewShown = viewShown else { return }
    //            switch viewShown {
    //            case .empty:
    //                infoLabel.text = "Search for podcasts"
    //            case .collection:
    //                print("collection")
    //            }
    //        }
    //    }
    
    let loadingPop = LoadingPopover()
    
    var searchBar: UISearchBar! {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var previousScrollOffset: CGFloat = 0
    let maxHeaderHeight: CGFloat = 74;
    let minHeaderHeight: CGFloat = 44;
    
    var headerHeightConstraint: NSLayoutConstraint!
    
    var titleTopConstraint: NSLayoutConstraint!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        edgesForExtendedLayout = []
        //tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLineEtched
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.height / 4
        edgesForExtendedLayout = []
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        self.automaticallyAdjustsScrollViewInsets = false
        searchBar = searchController.searchBar
        setup()
        searchControllerConfigure()
    }
    
    func setup() {
        searchController.delegate = self
        searchBar = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        let background = UIView()
        background.frame = UIScreen.main.bounds
        tableView.backgroundView = background
        background.addSubview(infoLabel)
        setupTableView()
        searchControllerConfigure()
        searchController.defaultConfiguration()
        searchBar.layoutIfNeeded()
        searchController.hidesNavigationBarDuringPresentation = false
        searchControllerConfigure()
        
        setupPlayerContainer()
        
        infoLabel.sizeToFit()
        infoLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
        infoLabel.isHidden = true
        tableView.layoutIfNeeded()
        searchController.searchBar.layoutIfNeeded()
        searchBar.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
        tableView.isUserInteractionEnabled = true
        tabBarController?.tabBar.alpha = 1
        navigationController?.navigationBar.alpha = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Search"
        searchControllerConfigure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.isActive = false
    }
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
        tableView.backgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.0)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        if #available(iOS 11.0, *) {
            view.add(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 40)
            headerHeightConstraint.isActive = true
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            headerView.add(searchController.searchBar)
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        titleTopConstraint = tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
        titleTopConstraint.isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 75 ||  scrollView.contentOffset.y < -75 {
            view.endEditing(true)
            searchBar.resignFirstResponder()
        }
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        self.titleTopConstraint.constant = -openAmount + 10
        // self.logoImageView.alpha = percentage
    }
    
    func setupPlayerContainer() {
        view.add(playerContainer)
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        playerContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        playerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        playerContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func searchControllerConfigure() {
        searchController.defaultConfiguration()
        searchBar.tintColor = .black
        searchBar.barTintColor = .white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
        searchBar.backgroundColor = .white
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            textFieldInsideSearchBar.clearButtonMode = .never
            textFieldInsideSearchBar.font = Style.Font.Search.searchBarTextFieldFont
            
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel "
            let item = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            let offset = UIOffset(horizontal: -20, vertical: 0)
            item.setTitlePositionAdjustment(offset, for: UIBarMetrics.default)
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(Style.Attributes.Search.searchFieldBarButtonItem, for: .normal)
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
            guard let playlist = playlist, let strongSelf = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
                        actionSheetController.dismiss(animated: false, completion: nil)
                    }
                    actionSheetController.addAction(okayAction)
                    strongSelf.present(actionSheetController, animated: false)
                }
                strongSelf.infoLabel.isHidden = true
                return
            }
            strongSelf.dataSource.items = playlist
            strongSelf.infoLabel.isHidden = true
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
        DispatchQueue.main.async {
            self.dataSource.items.removeAll()
            self.tableView.reloadData()
        }
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
        switch UIScreen.main.nativeBounds.height {
        case 480, 960, 1136, 1334:
            return UIScreen.main.bounds.height / 6
        case 2208:
            return UIScreen.main.bounds.height / 6.5
        default:
            return UIScreen.main.bounds.height / 6
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchController.isActive = false
        title = "Search"
    }
}

extension SearchViewController: UIScrollViewDelegate { }
