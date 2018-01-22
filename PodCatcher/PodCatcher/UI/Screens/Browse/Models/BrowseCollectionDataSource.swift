import UIKit

final class BrowseCollectionDataSource: BaseMediaControllerDataSource {
    
    var dataType: DataType = .network
    
    var topItemImage: UIImage!
    var items: [CasterSearchResult] = []
    var topViewItemIndex: Int = 0
    
    var reserveItems: [CasterSearchResult] = []
    let loadingQueue = OperationQueue()
    
    fileprivate var sections: [String] = []
    
    var loadingOperations: [IndexPath : TopPodcastLoadOperation] = [:]
    
    override var count: Int {
        return items.count
    }
    
    var cellModels: [TopPodcastCellViewModel] = []
    
    var categories: [String] = []
    
    var viewShown: ShowView {
        guard let casters = casters else { return .empty }
        if casters.count > 0 {
            return .collection
        } else {
            return .empty
        }
    }
    
    func topPodcastForItemAtIndexPath(_ indexPath: IndexPath) -> CasterSearchResult? {
        return items[indexPath.row]
    }
    
    func titleForSectionAtIndexPath(_ indexPath: IndexPath) -> String? {
        if (indexPath as NSIndexPath).section < sections.count {
            return sections[(indexPath as NSIndexPath).section]
        }
        return nil
    }
}

extension BrowseCollectionDataSource:  UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        let itemIndex = indexPath.row
        
        if items.count >= itemIndex && items.count > 0 {
            if let urlString = items[itemIndex].podcastArtUrlString,
                let url = URL(string: urlString),
                let title = items[itemIndex].podcastTitle {
                cell.configureCell(with: url, title: title)
            }
        }
        return cell
    }
}

extension BrowseCollectionDataSource: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TopPodcastCell else { return }
        if let urlString = items[indexPath.row].podcastArtUrlString,
            let url = URL(string: urlString),
            let title = items[indexPath.row].podcastTitle {
            cell.configureCell(with: url, title: title)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { return }
            if let topPocast = topPodcastForItemAtIndexPath(indexPath) {
                let dataLoader = TopPodcastLoadOperation(topPocast)
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
