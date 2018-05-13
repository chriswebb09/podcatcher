import Foundation

protocol PodcastDelegate: class {
    //func didAssignPlaylist(playlist: PodcastPlaylist)
    func didDeletePlaylist()
}
//
//struct FeedCoreDataStack {
//    
//    var feeds: [NSManagedObject] = []
//    
//    let managedContext: NSManagedObjectContext! = {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
//        return appDelegate.coreData.managedContext
//    }()
//    
//    
//    mutating func save(feedUrl: String, podcastTitle: String, episodeCount: Int, lastUpdate: NSDate, image: UIImage, uid: String, artworkUrlString: String, artistName: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.coreData.managedContext
//        let entity = NSEntityDescription.entity(forEntityName: "Subscription", in: managedContext)!
//        let subscription = NSManagedObject(entity: entity, insertInto: managedContext)
//        if let imageData = UIImageJPEGRepresentation(image, 1) {
//            subscription.setValue(feedUrl, forKeyPath: "feedUrl")
//            subscription.setValue(podcastTitle, forKeyPath: "podcastTitle")
//            subscription.setValue(artistName, forKeyPath: "podcastArtist")
//            subscription.setValue(NSData.init(data: imageData), forKey: "artworkImage")
//            subscription.setValue(episodeCount, forKey: "episodeCount")
//            subscription.setValue(lastUpdate, forKey: "lastUpdate")
//            subscription.setValue(uid, forKey: "uid")
//            subscription.setValue(artworkUrlString, forKey: "artworkImageUrl")
//        }
//        do {
//            try managedContext.save()
//            feeds.append(subscription)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//    
//    mutating func fetchFromCore() {
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Subscription")
//        do {
//            feeds = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
//}
