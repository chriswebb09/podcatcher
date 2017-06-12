import UIKit

// MARK: - UICollectionViewDelegate

extension MediaCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCaster(at: indexPath.row, with: dataSource.casters[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension MediaCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewShown = .collection
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let artWork = dataSource.casters[indexPath.row].artwork, let name = dataSource.casters[indexPath.row].name {
            let model = MediaCellViewModel(trackName: name, albumImageURL: artWork)
            cell.configureCell(with: model, withTime: 0)
            print(indexPath.row)
            cell.alpha = 1
        }
        return cell
    }
    
    func setupNavigationBar(navController: UINavigationController) {
        navController.navigationBar.barTintColor = UIColor(red:0.92, green:0.32, blue:0.33, alpha:1.0)
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }
}
