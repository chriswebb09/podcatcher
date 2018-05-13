import UIKit

final class BrowseCollectionDataSource: BaseMediaControllerDataSource {
    
    var dataType: DataType = .network
    
    var topItemImage: UIImage!
    var items: [PodcastItem] = []
    var topViewItemIndex: Int = 0
    
    var reserveItems: [PodcastItem] = []
    let loadingQueue = OperationQueue()
    
    fileprivate var sections: [String] = []
    
    var loadingOperations: [IndexPath : TopPodcastLoadOperation] = [:]
    
    override var count: Int {
        return items.count
    }
    
    var searchResultsDataStore = SearchResultsDataStore()
    
    override init() {
        super.init()
        
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        appDelegate.dataStore.getFeatured { podcasts in
            for pod in podcasts {
                let item = PodcastItem(podcastArtist: pod.podcastArtist, feedUrl: pod.feedUrl, podcastArtUrlString: pod.podcastArtUrlString, artistId: pod.artistId, id: pod.id, podcastTitle: pod.podcastTitle, episodes: [], category: "")
                self.items.append(item)
            }
        }
        //getFeaturedPodcasts(completion: { podcasts, errors in
            
            
       // })
        
        
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
    
    func topPodcastForItemAtIndexPath(_ indexPath: IndexPath) -> PodcastItem? {
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
            if let url = URL(string: items[indexPath.row].podcastArtUrlString) {
                cell.configureCell(with: url, title: items[indexPath.row].podcastTitle)
            }
        }
       
        return cell
    }
}

extension BrowseCollectionDataSource: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TopPodcastCell else { return }
        if let url = URL(string: items[indexPath.row].podcastArtUrlString) {
            cell.configureCell(with: url, title: items[indexPath.row].podcastTitle)
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
