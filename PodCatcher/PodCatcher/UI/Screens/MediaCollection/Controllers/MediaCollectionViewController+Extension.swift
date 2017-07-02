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
        collectionView.backgroundColor = .clear
    }
}

extension MediaCollectionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y > 0 {
            hideLoadingView(loadingPop: loadingPop)
            hideSearchBar()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MediaCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showLoadingView(loadingPop: loadingPop)
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
        let rowTime = (Double(indexPath.row % 8)) / 10
        setTrackCell(indexPath: indexPath, cell: cell, rowTime: rowTime)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath:IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "reusableHeaderView", for: indexPath)
        return headerView
    }
}

extension MediaCollectionViewController:  UISearchControllerDelegate {
    
    func searchBarHasInput() {
        showLoadingView(loadingPop: loadingPop)
        loadingPop.configureLoadingOpacity()
        dataSource.store.searchForTracks { [weak self] playlist, error in
            guard let playlist = playlist, let strongSelf = self else { return }
            strongSelf.dataSource.items = playlist
            strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.performBatchUpdates ({
                self?.collectionView.reloadData()
                DispatchQueue.main.async {
                    if strongSelf.collectionView.indexPathsForVisibleItems.count > 0 {
                        strongSelf.collectionView.reloadItems(at: strongSelf.collectionView.indexPathsForVisibleItems)
                        strongSelf.collectionView.isHidden = false
                        strongSelf.view.bringSubview(toFront: strongSelf.collectionView)
                    }
                }
            }, completion: { finished in
                print(finished)
            })
        }
    }
    
    func searchOnTextChange(text: String, store: TrackDataStore, navController: UINavigationController) {
        if text == "" {
            self.dataSource.items.removeAll()
            self.collectionView.reloadData()
            navController.navigationBar.topItem?.title = "PodCatch"
            return
        } else if text != "" {
            searchBarActive = true
            dataSource.store.setSearch(term: text)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchBarHasInput), object: nil)
            self.perform(#selector(searchBarHasInput), with: nil, afterDelay: 0.35)
            navController.navigationBar.topItem?.title = "Search: \(text)"
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
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setSearch), object: nil)
                self.perform(#selector(setSearch), with: nil, afterDelay: 0.35)
            }
        }
        collectionView.reloadData()
    }
    
    func setSearch() {
        self.dataSource.store.searchForTracks { [weak self] tracks, error in
            guard let strongSelf = self, let tracks = tracks else { return }
            strongSelf.dataSource.items = tracks
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        view.addSubview(searchBar)
        view.bringSubview(toFront: collectionView)
        leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button"), style: .done, target: self, action: #selector(hideSearchBar))
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
    }
    
    func hideSearchBar() {
        searchBar.removeFromSuperview()
        segmentControl.removeFromSuperview()
        searchBarActive = false
        leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button"), style: .done, target: self, action: #selector(search))
        navigationItem.setLeftBarButton(leftButtonItem, animated: false)
        if dataSource.items.count == 0 { viewShown = .empty }
        guard let nav = navigationController?.navigationBar else { return }
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: nav.frame.maxY - 46, width: UIScreen.main.bounds.width, height: view.frame.height)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
        view.bringSubview(toFront: searchBar)
    }
}

extension MediaCollectionViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideLoadingView(loadingPop: loadingPop)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideLoadingView(loadingPop: loadingPop)
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
    }
}
