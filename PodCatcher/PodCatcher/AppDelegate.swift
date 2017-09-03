import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainCoordinator: MainCoordinator!
    var backgroundSessionCompletionHandler: (() -> Void)?
    var coreData: CoreDataStack!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationStyling.setupUI()
        
        coreData = CoreDataStack(modelName: "PodCatcher")
        
        #if CLEAR_CACHES
            let cachesFolderItems = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            for item in cachesFolderItems {
                try? FileManager.default.removeItem(atPath: item)
            }
        #endif
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("podcasts")
        
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        
        if let window = window {
            let startCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
            mainCoordinator = MainCoordinator(window: window, coordinator: startCoordinator)
            mainCoordinator.start()
        }
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("background")
        backgroundSessionCompletionHandler = completionHandler
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreData.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PodCatcher")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
