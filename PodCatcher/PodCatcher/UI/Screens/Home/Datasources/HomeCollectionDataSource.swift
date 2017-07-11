import UIKit
import CoreData

final class HomeCollectionDataSource: BaseMediaControllerDataSource {
    
    var dataType: DataType = .network
    
    var topStore = TopPodcastsDataStore()
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

extension HomeCollectionDataSource:  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataType {
        case .local:
            return topStore.podcasts.count
        case .network:
            return items.count
        }
    }
    
    fileprivate func setCell(indexPath: IndexPath, cell: TopPodcastCell, rowTime: Double) {
        switch dataType {
        case .local:
            if let title = self.topStore.podcasts[indexPath.row].value(forKey: "podcastTitle") as? String, let imageData = self.topStore.podcasts[indexPath.row].value(forKey: "podcastArt") as? Data, let image = UIImage(data: imageData) {
                let cellViewModel = TopPodcastCellViewModel(trackName: title, podcastImage: image)
                cell.configureCell(with: cellViewModel, withTime: 0)
            }
        case .network:
            if let urlString = items[indexPath.row].podcastArtUrlString,
                let url = URL(string: urlString),
                let title = items[indexPath.row].podcastTitle {
                UIImage.downloadImage(url: url) { image in
                    let cellViewModel = TopPodcastCellViewModel(trackName: title, podcastImage: image)
                    cell.configureCell(with: cellViewModel, withTime: 0)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + rowTime) {
            UIView.animate(withDuration: rowTime) {
                cell.alpha = 0.98
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        switch dataType {
        case .local:
            if indexPath.row == 0, let imageData = self.topStore.podcasts[indexPath.row].value(forKey: "podcastArt") as? Data, let image = UIImage(data: imageData) {
            }
        case .network:
            if indexPath.row == 0 || indexPath.row == 1 {
                reserveItems.append(items[indexPath.row])
            }
        }
        setCell(indexPath: indexPath, cell: cell, rowTime: 0)
        return cell
    }
}
