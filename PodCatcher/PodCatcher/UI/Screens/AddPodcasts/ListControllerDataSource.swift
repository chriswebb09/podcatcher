import UIKit

class ListControllerDataSource: TracksDataSource {
    
    var count: Int {
        return items.count
    }
    
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysTemplate)
    var items = [PodcastSearchResult]()
    var store: TrackDataStore
    
    var user: PodCatcherUser?
    
    init(store: TrackDataStore, user: PodCatcherUser?) {
        self.store = store
        self.user = user 
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TrackCell
        if let urlString = items[indexPath.row].podcastArtUrlString,
            let url = URL(string: urlString),
        let title = items[indexPath.row].podcastTitle {
            let cellViewModel = TrackCellViewModel(trackName: title, albumImageUrl: url)
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
