import UIKit

extension MediaCollectionViewController: CollectionViewProtocol {
    
    func logout() {
        delegate?.logoutTapped(logout: true)
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
        delegate?.didSelect(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension MediaCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            self.viewShown = .empty
        }
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewShown = .collection
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let artWork = dataSource.casters[indexPath.row].artwork, let name = dataSource.casters[indexPath.row].name {
            let model = MediaCellViewModel(trackName: name, albumImageURL: artWork)
            cell.configureCell(with: model, withTime: (Double(indexPath.row) * 0.01))
        }
        return cell
    }
}
