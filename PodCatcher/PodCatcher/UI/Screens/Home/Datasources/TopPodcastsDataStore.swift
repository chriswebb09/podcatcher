import UIKit
import CoreData

final class TopPodcastsDataStore {
    
    var podcasts: [NSManagedObject] = []
    
    func save(podcastItem: CasterSearchResult) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        guard let imageUrlString = podcastItem.podcastArtUrlString,
            let imageUrl = URL(string: imageUrlString), let title = podcastItem.podcastTitle,
            let feedUrlString = podcastItem.feedUrl else { return }
        
        UIImage.downloadImage(url: imageUrl) { image in
            
            let podcastArtImageData = UIImageJPEGRepresentation(image, 1) as? Data
            let managedContext = appDelegate.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "TopPodcast", in: managedContext) else { return }
            let podcast = NSManagedObject(entity: entity, insertInto: managedContext)
            
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TopPodcast")
        do {
            podcasts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
