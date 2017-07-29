import UIKit

protocol CollectionViewProtocol {
    var collectionView: UICollectionView { get set }
    func collectionViewConfigure(collectionViewDelegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource)
}

extension CollectionViewProtocol {
    func collectionViewConfigure(collectionViewDelegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = dataSource
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
    }
}
