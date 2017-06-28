import UIKit

extension SearchViewController: UICollectionViewDataSource {
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        searchBar = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: navController.navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: 0)
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        view.addSubview(searchBar)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.leftView?.alpha = 0
        searchBar.alpha = 0.7
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
    
    func popBottomMenu(popped: Bool) {
        sideMenuPop.setupPop()
        showMenu()
    }
    
    func emptyViewShower() {
        setSearchBarActive()
        willPresentSearchController(searchController)
        view.bringSubview(toFront: collectionView)
        dump(collectionView.delegate)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

extension SearchViewController: TrackCellCollectionProtocol {
    
    func setupCollectionView(collectionView: UICollectionView, view: UIView, newLayout: TrackItemsFlowLayout) {
        collectionView.setup(with: newLayout)
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        view.bringSubview(toFront: emptyView)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(at: indexPath.row)
    }
}

// MARK: - UISearchController Delegate

extension SearchViewController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("text")
        setSearchBarActive()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        setSearchBarActive()
        willPresentSearchController(searchController)
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBarActive {
            collectionView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarHasInput() {
        collectionView.reloadData()
        dataSource.store.searchForTracks { [weak self] playlist, error in
            guard let playlist = playlist, let strongSelf = self else { return }
            strongSelf.dataSource.items = playlist
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.performBatchUpdates ({
                DispatchQueue.main.async {
                    strongSelf.collectionView.reloadItems(at: strongSelf.collectionView.indexPathsForVisibleItems)
                    strongSelf.collectionView.isHidden = false
                    strongSelf.view.bringSubview(toFront: strongSelf.collectionView)
                }
            }, completion: { finished in
                print(finished)
            })
        }
    }
    
    func searchOnTextChange(text: String, store: TrackDataStore, navController: UINavigationController) {
        dataSource.store.setSearch(term: text)
        searchBarActive = true
        if text != "" { searchBarHasInput() }
        navController.navigationBar.topItem?.title = "Search: \(text)"
        UIView.animate(withDuration: 1.8) {
            self.collectionView.alpha = 1
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text, let navcontroller = self.navigationController else { return }
        searchOnTextChange(text: barText, store: dataSource.store, navController: navcontroller)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString != nil {
            dataSource.items.removeAll()
            if let searchString = searchString {
                self.dataSource.store.setSearch(term: searchString)
                self.dataSource.store.searchForTracks { [weak self] tracks, error in
                    guard let strongSelf = self, let tracks = tracks else { return }
                    strongSelf.dataSource.items = tracks
                }
            }
        }
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
        view.bringSubview(toFront: searchBar)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        view.addSubview(searchBar)
        view.bringSubview(toFront: collectionView)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource.items.removeAll()
        collectionView.reloadData()
        searchBarActive = false
    }
}
