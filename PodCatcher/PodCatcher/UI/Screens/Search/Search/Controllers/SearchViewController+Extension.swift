import UIKit
import ReachabilitySwift

extension SearchViewController: UISearchResultsUpdating {
    
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
                DispatchQueue.main.async {
                    let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
                        actionSheetController.dismiss(animated: false, completion: nil)
                    }
                    actionSheetController.addAction(okayAction)
                    self?.present(actionSheetController, animated: false)
                }
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
        tableView.isUserInteractionEnabled = false
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if self.dataSource.items.count > 0 {
                    self.searchController.isActive = false
                    self.delegate?.didSelect(at: indexPath.row, with: self.dataSource.items[indexPath.row])
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
                let okayAction: UIAlertAction =  UIAlertAction(title: "Okay", style: .cancel) { action in
                    tableView.isUserInteractionEnabled = true
                    actionSheetController.dismiss(animated: false, completion: nil)
                }
                actionSheetController.addAction(okayAction)
                self.present(actionSheetController, animated: false)
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
