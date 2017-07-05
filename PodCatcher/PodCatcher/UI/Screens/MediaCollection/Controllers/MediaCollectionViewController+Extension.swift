import UIKit

extension MediaCollectionViewController: CollectionViewProtocol {
    
    func logout() {
        delegate?.logout(tapped: true)
    }
    
    func collectionViewConfiguration() {
        collectionView.setupCollectionView(view: view, newLayout: TrackItemsFlowLayout())
        collectionView.collectionViewRegister(viewController: self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .clear
    }
}

extension MediaCollectionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        hideLoadingView(loadingPop: loadingPop)
        if offset.y > 0 {
            hideSearchBar()
            switch sideMenuPop.state {
            case .active:
                hideMenu()
            default:
                break
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MediaCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showLoadingView(loadingPop: loadingPop)
        delegate?.didSelect(at: indexPath.row, with: dataSource.items[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath:IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "reusableHeaderView", for: indexPath)
        return headerView
    }
}

extension MediaCollectionViewController:  UISearchControllerDelegate {
    
    func searchBarHasInput() {
        if loadingPop.animating {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showLoadingView(loadingPop:)), object: nil)
        }
        showLoadingView(loadingPop: loadingPop)
        loadingPop.configureLoadingOpacity()
        dataSource.store.searchForTracks { [weak self] playlist, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let playlist = playlist, let strongSelf = self else { return }
            if strongSelf.loadingPop.animating {
                 strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
            }
            strongSelf.dataSource.items = playlist
            strongSelf.hideLoadingView(loadingPop: strongSelf.loadingPop)
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.performBatchUpdates ({
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
    
    func searchOnTextChange(text: String, store: SearchResultsFetcher, navController: UINavigationController) {
        if text == "" {
            dataSource.items.removeAll()
            collectionView.reloadData()
            navController.navigationBar.topItem?.title = "PodCatch"
            return
        } else if text != "" {
            searchBarActive = true
            dataSource.store.setSearch(term: text)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchBarHasInput), object: nil)
            perform(#selector(searchBarHasInput), with: nil, afterDelay: 0.35)
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
    }
    
    func setSearch() {
        if loadingPop.animating {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showLoadingView(loadingPop:)), object: nil)
        }
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
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
        view.bringSubview(toFront: searchBar)
    }
}

extension MediaCollectionViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource.items.removeAll()
        hideLoadingView(loadingPop: loadingPop)
        if loadingPop.animating {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showLoadingView(loadingPop:)), object: nil)
        }
        DispatchQueue.main.async {
            self.title = "PodCatch"
            self.hideSearchBar()
            self.collectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideLoadingView(loadingPop: loadingPop)
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
    }
    
    func navigationBarSetup() {
        guard let navController = self.navigationController else { return }
        collectionView.register(TrackCell.self)
        collectionView.delegate = self
        searchController.searchBar.frame = CGRect(x: UIScreen.main.bounds.minX, y: navController.navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: 0)
        collectionView.frame = CGRect(x: UIScreen.main.bounds.minX, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        view.addSubview(searchBar)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        searchBar.alpha = 0.7
    }
    
    func popBottomMenu(popped: Bool) {
        hideSearchBar()
        sideMenuPop.setupPop()
        showMenu()
    }
    
    func search() {
        searchBarActive = true
        willPresentSearchController(searchController)
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
    
    func userSearch(segmentControl: UISegmentedControl){
        switch segmentControl.selectedSegmentIndex{
        case 0:
            print(0)
        case 1:
            print(1)
        case 2:
            print(3)
        default:
            break
        }
    }
}

extension MediaCollectionViewController: SideMenuDelegate {
    
    func optionOne(tapped: Bool) {
        print(tapped)
        delegate?.logout(tapped: true)
    }
    
    func optionTwo(tapped: Bool) {
        print(tapped)
    }
    
    func optionThree(tapped: Bool) {
        print(tapped)
    }
}
