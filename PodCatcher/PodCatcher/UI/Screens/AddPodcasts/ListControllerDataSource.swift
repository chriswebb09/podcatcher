import UIKit

class ListControllerDataSource: TracksDataSource {
    
    var count: Int {
        return items.count
    }
    
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysTemplate)
    var items = [PodcastSearchResult]()
    var store: TrackDataStore
    
    init(store: TrackDataStore) {
        self.store = store
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TrackCell
        if let urlString = items[indexPath.row].podcastArtUrlString, let url = URL(string: urlString) {
            let cellViewModel = TrackCellViewModel(albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: (Double(indexPath.row) * 0.1))
        }
        return cell
    }
}

extension ListControllerDataSource: TrackStateProtocol {
    
    var state: TrackContentState {
        return getState(for: count)
    }
}
