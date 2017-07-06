import UIKit

extension SearchViewController: UISearchResultsUpdating {
    
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
    
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResultsForSearchController(searchController: searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString != nil {
            dataSource.items.removeAll()
            if let searchString = searchString {
                self.dataSource.store.setSearch(term: searchString)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setSearch), object: nil)
                self.perform(#selector(setSearch), with: nil, afterDelay: 0.35)
            }
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
    func setSearch() {
        self.dataSource.store.searchForTracks { [weak self] tracks, error in
            guard let strongSelf = self, let tracks = tracks else { return }
            strongSelf.dataSource.items = tracks
        }
    }
    
    func searchBarHasInput() {
        dataSource.store.searchForTracks { [weak self] playlist, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let playlist = playlist, let strongSelf = self else { return }
            strongSelf.dataSource.items = playlist
            strongSelf.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchOnTextChange(text: String, store: SearchResultsFetcher, navController: UINavigationController) {
        if text == "" {
            dataSource.items.removeAll()
            tableView.reloadData()
            navController.navigationBar.topItem?.title = "PodCatch"
            return
        }
        searchBarActive = true
        dataSource.store.setSearch(term: text)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchBarHasInput), object: nil)
        perform(#selector(searchBarHasInput), with: nil, afterDelay: 0.35)
        navController.navigationBar.topItem?.title = "Search: \(text)"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text, let navcontroller = self.navigationController else { return }
        searchOnTextChange(text: barText, store: dataSource.store, navController: navcontroller)
    }
}
