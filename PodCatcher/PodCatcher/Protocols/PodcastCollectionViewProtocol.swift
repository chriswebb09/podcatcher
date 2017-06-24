import UIKit

protocol PodcastCollectionViewProtocol: CollectionViewProtocol { }

extension PodcastCollectionViewProtocol {
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(PodcastCell.self)
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
}
