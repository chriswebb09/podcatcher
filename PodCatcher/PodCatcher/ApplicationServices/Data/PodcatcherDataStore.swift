import UIKit
import CoreData

class PodcatcherDataStore {
    
    var podCasters: [NSManagedObject] = []
    
    func pullPodcastsFromUser(completion: @escaping ([Caster]?) -> Void) {
        var lists = [Caster]()
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PodCaster", in: managedContext)!
        let podCaster = NSManagedObject(entity: entity, insertInto: managedContext)
        podCaster.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            podCasters.append(podCaster)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
