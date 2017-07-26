import UIKit
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

class FeedCoreDataStack {
    var feeds: [NSManagedObject] = []
    
    func save(feedUrl: String, podcastTitle: String, episodeCount: Int, lastUpdate: NSDate, image: UIImage, uid: String, artworkUrlString: String, artistName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "Subscription", in: managedContext)!
        let subscription = NSManagedObject(entity: entity, insertInto: managedContext)
        if let podcastArtImageData = UIImageJPEGRepresentation(image, 1) as? NSData {
            subscription.setValue(feedUrl, forKeyPath: "feedUrl")
            subscription.setValue(podcastTitle, forKeyPath: "podcastTitle")
            subscription.setValue(artistName, forKeyPath: "podcastArtist")
            subscription.setValue(podcastArtImageData, forKey: "artworkImage")
            subscription.setValue(episodeCount, forKey: "episodeCount")
            subscription.setValue(lastUpdate, forKey: "lastUpdate")
            subscription.setValue(uid, forKey: "uid")
            subscription.setValue(artworkUrlString, forKey: "artworkImageUrl")
        }
        do {
            try managedContext.save()
            feeds.append(subscription)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Subscription")
        do {
            feeds = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

class PlaylistsCoreDataStack {
    
    var playlists: [NSManagedObject] = []
    
    func save(name: String, uid: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        guard let entity = NSEntityDescription.entity(forEntityName: "PodcastPlaylist", in: managedContext) else { return }
        let playlist = NSManagedObject(entity: entity, insertInto: managedContext)
        let id = UUID().uuidString
        let date = NSDate()
        playlist.setValue(name, forKeyPath: "playlistName")
        playlist.setValue(id, forKey: "playlistId")
        playlist.setValue(date, forKey: "dateCreated")
        playlist.setValue(0, forKey: "timeSpentListening")
        playlist.setValue(0, forKey: "numberOfItems")
        playlist.setValue(0, forKey: "numberOfPlays")
        playlist.setValue(uid, forKey: "uid")
        do {
            try managedContext.save()
            playlists.append(playlist)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PodcastPlaylist")
        do {
            playlists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
