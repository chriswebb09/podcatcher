import Foundation
import CoreData

class CoreDataStack {
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:
            self.managedObjectModel)
        let storeURL = self.applicationDocumentsDirectory().appendingPathComponent("PodCatcher.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print("Unresolved error adding persistent store: \(error)")
        }
        return coordinator
    }()
    
    
    private func applicationDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "PodCatcher", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    func loadDefaultOnFirstLaunch() -> Bool {
        let key = "hasLaunchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: key)
        if launchedBefore == false {
            UserDefaults.standard.set(true, forKey: key)
            return false
        }
        return true
    }
}
