import UIKit

extension MediaCollectionViewController: CollectionViewProtocol {
    
    func logout() {
        delegate?.logout(tapped: true)
    }
    
    func collectionViewConfiguration() {
        collectionView.setupCollectionView(view: view, newLayout: TrackItemsFlowLayout())
        collectionView.collectionViewRegister(viewController: self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension MediaCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { 
        delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension MediaCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.collectionView(collectionView, numberOfItemsInSection: 0) > 0 {
            viewShown = .collection
        }
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

extension MediaCollectionViewController:  UISearchControllerDelegate {
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

extension MediaCollectionViewController: UISearchResultsUpdating {
    
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
    
    func willPresentSearchController(_ searchController: UISearchController) {
        view.addSubview(searchBar)
        view.bringSubview(toFront: collectionView)
        leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button"), style: .done, target: self, action: #selector(hideSearchBar))
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
    }
    
    func hideSearchBar() {
        searchBar.removeFromSuperview()
        searchBarActive = false
        leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button"), style: .done, target: self, action: #selector(search))
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        if dataSource.items.count == 0 {
            viewShown = .empty
        }
        guard let nav = navigationController?.navigationBar else { return }
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: nav.frame.maxY - 46, width: UIScreen.main.bounds.width, height: view.frame.height)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
        view.bringSubview(toFront: searchBar)
    }
}

extension MediaCollectionViewController: UISearchBarDelegate {
    
}
