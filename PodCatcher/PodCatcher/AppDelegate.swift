import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainCoordinator: MainCoordinator!
    var backgroundSessionCompletionHandler: (() -> Void)?
    var coreData: CoreDataStack!
    var audioPlayer: AudioFilePlayer!
    var dataStore: DataStore!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationStyling.setupUI()
        dataStore = DataStore(notificationCenter: .default)
        dataStore.setFeatured()
        
        coreData = CoreDataStack(modelName: "Podcatch")
        
        #if CLEAR_CACHES
            let cachesFolderItems = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            for item in cachesFolderItems {
                try? FileManager.default.removeItem(atPath: item)
            }
        #endif
        audioPlayer = AudioFilePlayer()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("podcasts")
        
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(beginInterruption), name: .AVAudioSessionInterruption, object: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AudioSession active!")
        } catch {
            print("No AudioSession!! Don't know what do to here. ")
        }
        
        if let window = window {
            let startCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
            mainCoordinator = MainCoordinator(window: window, coordinator: startCoordinator, persistentContainer: persistentContainer)
            mainCoordinator.start()
        }
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("background")
        backgroundSessionCompletionHandler = completionHandler
    }
    
    @objc func beginInterruption() {
        guard audioPlayer != nil else { return }
        audioPlayer.pause()
        print("interrupted")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreData.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Podcatch")
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
