import UIKit

protocol TracksDataSource: DataSourceProtocol {
    var state: TrackContentState { get }
    var image: UIImage { get }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
