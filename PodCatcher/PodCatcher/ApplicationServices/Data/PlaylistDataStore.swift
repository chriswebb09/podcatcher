import UIKit
import CoreData

class PlaylistsDataStore {
    
    var playlists: [NSManagedObject] = []
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TestPlaylist", in: managedContext)!
        let playlist = NSManagedObject(entity: entity, insertInto: managedContext)
        playlist.setValue(name, forKeyPath: "title")
        do {
            try managedContext.save()
            playlists.append(playlist)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
            NSFetchRequest<NSManagedObject>(entityName: "TestPlaylist")
        do {
            playlists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
