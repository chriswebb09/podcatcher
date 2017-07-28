import UIKit

final class BrowseCollectionDataSource: BaseMediaControllerDataSource {
    
    var dataType: DataType = .network
    
    var topItemImage: UIImage!
    var items = [CasterSearchResult]()
    var topViewItemIndex: Int = 0
    var reserveItems = [CasterSearchResult]()
    
    var cellModels = [TopPodcastCellViewModel]()
    
    var categories: [String] = []
    
    var viewShown: ShowView {
        guard let casters = casters else { return .empty }
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
}

extension BrowseCollectionDataSource:  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    fileprivate func setCell(indexPath: IndexPath, cell: TopPodcastCell, rowTime: Double) {
        if let urlString = items[indexPath.row].podcastArtUrlString,
            let url = URL(string: urlString),
            let title = items[indexPath.row].podcastTitle {
            UIImage.downloadImage(url: url) { image in
                let cellViewModel = TopPodcastCellViewModel(trackName: title, podcastImage: image)
                cell.configureCell(with: cellViewModel, withTime: 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        if indexPath.row == 0 || indexPath.row == 1 {
            reserveItems.append(items[indexPath.row])
        }
        setCell(indexPath: indexPath, cell: cell, rowTime: 0)
        return cell
    }
}
