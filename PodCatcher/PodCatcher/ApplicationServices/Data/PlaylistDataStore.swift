import UIKit
import CoreData

class PlaylistsDataStore {
    
    var playlists: [NSManagedObject] = []
    
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Playlists", in: managedContext)!
        let podCaster = NSManagedObject(entity: entity, insertInto: managedContext)
        podCaster.setValue(name, forKeyPath: "userID")
        do {
            try managedContext.save()
            playlists.append(podCaster)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
