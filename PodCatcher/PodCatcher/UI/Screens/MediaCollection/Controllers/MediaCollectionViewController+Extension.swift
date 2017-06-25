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
        delegate?.didSelect(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension MediaCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.collectionView(collectionView, numberOfItemsInSection: 0) > 0 {
            viewShown = .collection
        }
        return dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
}


//extension MediaCollectionViewController: CollectionViewProtocol {
//    
//    func logout() {
//        delegate?.logout(tapped: true)
//    }
//    
//    func collectionViewConfiguration() {
//        collectionView.setupCollectionView(view: view, newLayout: TrackItemsFlowLayout())
//        collectionView.collectionViewRegister(viewController: self)
//        collectionView.delegate = self
//        collectionView.dataSource = dataSource
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//
//extension MediaCollectionViewController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.didSelect(at: indexPath.row)
//    }
//}
//
//extension MediaCollectionViewController: MenuDelegate {
//    
//    func optionThreeTapped() {
//        
//    }
//    
//    func optionTwoTapped() {
//        
//    }
//    
//    func optionOneTapped() {
//        
//    }
//}
