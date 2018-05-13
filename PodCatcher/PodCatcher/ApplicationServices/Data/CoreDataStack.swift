import UIKit
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        self.storeContainer.viewContext.automaticallyMergesChangesFromParent = true
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllData(_ entity: String) {
        
        print("truncating table \(entity) ...")
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                managedContext.delete(managedObject)
            }
            try managedContext.save()
            managedContext.reset()
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}

extension NSManagedObjectContext {
    func deleteEntities<Entity: NSManagedObject>(ofType type: Entity.Type) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try execute(deleteRequest)
        try save()
    }
}

struct FeedCoreDataStack {
    
    var feeds: [NSManagedObject] = []
    
    let managedContext: NSManagedObjectContext! = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.coreData.managedContext
    }()
    
    mutating func save(feedUrl: String, podcastTitle: String, episodeCount: Int, lastUpdate: NSDate, image: UIImage, uid: String, artworkUrlString: String, artistName: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Subscription", in: managedContext)!
        let subscription = NSManagedObject(entity: entity, insertInto: managedContext)
        if let imageData = UIImageJPEGRepresentation(image, 1) {
            subscription.setValue(feedUrl, forKeyPath: "feedUrl")
            subscription.setValue(podcastTitle, forKeyPath: "podcastTitle")
            subscription.setValue(artistName, forKeyPath: "podcastArtist")
            subscription.setValue(NSData.init(data: imageData), forKey: "artworkImage")
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
    
    mutating func fetchFromCore() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Subscription")
        do {
            feeds = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}


//class CoreDataStack {
//
//    private let modelName: String
//
//    lazy var storeContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: self.modelName)
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error as NSError? {
//                print("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
//
//    lazy var managedContext: NSManagedObjectContext = {
//         self.storeContainer.viewContext.automaticallyMergesChangesFromParent = true
//        return self.storeContainer.viewContext
//    }()
//
//    init(modelName: String) {
//        self.modelName = modelName
//    }
//
//    func saveContext() {
//        guard managedContext.hasChanges else { return }
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Unresolved error \(error), \(error.userInfo)")
//        }
//    }
//}
