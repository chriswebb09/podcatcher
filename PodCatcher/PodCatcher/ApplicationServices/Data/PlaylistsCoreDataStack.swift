import UIKit
import CoreData

class PlaylistsCoreDataStack {
    
    var playlists: [NSManagedObject] = []
    
    func save(name: String, uid: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
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

