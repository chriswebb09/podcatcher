import UIKit
import CoreData

enum DataType {
    case local, network
}

class HomeCollectionDataSource: BaseMediaControllerDataSource {
    var dataType: DataType = .network
    let store = SearchResultsDataStore()
    let fetcher = SearchResultsFetcher()
    
    var lookup: String = "" {
        didSet {
            fetcher.setLookup(term: lookup)
        }
    }
    
    var topStore = TopPodcastsDataStore()
    var topItemImage: UIImage!
    var items = [CasterSearchResult]()
    var topViewItemIndex: Int = 0
    var reserveItems = [CasterSearchResult]()
    
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
                cell.alpha = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        switch dataType {
        case .local:
            if indexPath.row == 0, let imageData = self.topStore.podcasts[indexPath.row].value(forKey: "podcastArt") as? Data, let image = UIImage(data: imageData) {
                topItemImage = image
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


class TopPodcastsDataStore {
    
    var podcasts: [NSManagedObject] = []
    
    func save(podcastItem: CasterSearchResult) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let imageUrlString = podcastItem.podcastArtUrlString, let imageUrl = URL(string: imageUrlString), let title = podcastItem.podcastTitle, let feedUrlString = podcastItem.feedUrl else { return }
        UIImage.downloadImage(url: imageUrl) { image in
            let podcastArtImageData = UIImageJPEGRepresentation(image, 1) as! NSData
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "TopPodcast", in: managedContext)!
            let  podcast = NSManagedObject(entity: entity, insertInto: managedContext)
            podcast.setValue(podcastArtImageData, forKeyPath: "podcastArt")
            podcast.setValue(podcastItem.id, forKey: "itunesId")
            podcast.setValue(title, forKey: "podcastTitle")
            podcast.setValue(feedUrlString, forKey: "podcastFeedUrlString")
            do {
                try managedContext.save()
                self.podcasts.append(podcast)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchFromCore() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TopPodcast")
        do {
            podcasts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
