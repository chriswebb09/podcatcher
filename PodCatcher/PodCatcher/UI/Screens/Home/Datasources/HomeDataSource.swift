import UIKit
import CoreData

class HomeDataSource: BaseMediaControllerDataSource, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SubscribedPodcastCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
}

final class BrowseCollectionDataSource: BaseMediaControllerDataSource {
    
    var dataType: DataType = .network
    
    var podcasts: [NSManagedObject] = []

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
    
    func fetchFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TopPodcast")
        do {
            podcasts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension BrowseCollectionDataSource:  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataType {
        case .local:
            return podcasts.count
        case .network:
            return items.count
        }
    }
    
    fileprivate func setCell(indexPath: IndexPath, cell: TopPodcastCell, rowTime: Double) {
        switch dataType {
        case .local:
            if let title = podcasts[indexPath.row].value(forKey: "podcastTitle") as? String,
                let imageData = podcasts[indexPath.row].value(forKey: "podcastArt") as? Data,
                let image = UIImage(data: imageData) {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopPodcastCell
        switch dataType {
        case .local:
            break
        case .network:
            if indexPath.row == 0 || indexPath.row == 1 {
                reserveItems.append(items[indexPath.row])
            }
        }
        setCell(indexPath: indexPath, cell: cell, rowTime: 0)
        return cell
    }
}
