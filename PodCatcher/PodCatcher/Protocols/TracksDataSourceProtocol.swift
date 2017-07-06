import UIKit

protocol TracksDataSource: DataSourceProtocol {
    var image: UIImage { get }
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
