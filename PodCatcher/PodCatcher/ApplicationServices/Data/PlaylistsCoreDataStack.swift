import UIKit
import CoreData

class PlaylistsCoreDataStack {
    
    var playlists: [NSManagedObject] = []
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PodcastPlaylist", in: managedContext)!
        let playlist = NSManagedObject(entity: entity, insertInto: managedContext)
        let id = UUID().uuidString
        let date = NSDate()
        playlist.setValue(name, forKeyPath: "playlistName")
        playlist.setValue(id, forKey: "playlistId")
        playlist.setValue(date, forKey: "dateCreated")
        playlist.setValue(0, forKey: "timeSpentListening")
        playlist.setValue(0, forKey: "numberOfItems")
        playlist.setValue(0, forKey: "numberOfPlays")
        do {
            try managedContext.save()
            playlists.append(playlist)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchFromCore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PodcastPlaylist")
        do {
            playlists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

//@NSManaged public var artwork: NSData?
//@NSManaged public var dateCreated: NSDate?
//@NSManaged public var numberOfItems: Int32
//@NSManaged public var numberOfPlays: Int32
//@NSManaged public var playlistId: String?
//@NSManaged public var playlistName: String?
//@NSManaged public var timeSpentListening: Double
//@NSManaged public var podcast: NSSet?
