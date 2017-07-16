import UIKit

extension SearchViewController: UISearchResultsUpdating {
    
    func showSearchBar() {
        guard let tabbar = self.tabBarController?.tabBar else { return }
        searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: 44)
        tableView.frame = CGRect(x: UIScreen.main.bounds.minX, y: searchBar.frame.maxY, width: UIScreen.main.bounds.width, height: (view.frame.height - tabbar.frame.height) + 5)
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
            if let searchString = searchString, searchString != "" {
                self.dataSource.store.setSearch(term: searchString)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setSearch), object: nil)
                self.perform(#selector(setSearch), with: nil, afterDelay: 0)
            }
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
    func setSearch() {
        dataSource.store.searchForTracks { [weak self] playlist, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let playlist = playlist, let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.dataSource.items = playlist
                strongSelf.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchOnTextChange(text: String, store: SearchResultsFetcher, navController: UINavigationController) {
        if text == "" {
            dataSource.items.removeAll()
            navController.navigationBar.topItem?.title = "Search"
            tableView.reloadData()
            return
        } else if text != "" {
            searchBarActive = true
            dataSource.store.setSearch(term: text)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setSearch), object: nil)
            self.perform(#selector(setSearch), with: nil, afterDelay: 0.35)
            navController.navigationBar.topItem?.title = "Search: \(text)"
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text, let navcontroller = self.navigationController else { return }
        searchOnTextChange(text: barText, store: dataSource.store, navController: navcontroller)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.items.count > 0 {
            searchBarActive = false
            searchController.isActive = false
            delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
        searchController.isActive = false
        DispatchQueue.main.async {
            self.title = "Search"
        }
    }
}
