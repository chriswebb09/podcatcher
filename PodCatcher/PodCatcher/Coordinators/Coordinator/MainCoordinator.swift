import UIKit
import Firebase
import ReachabilitySwift
import CoreData

class MainCoordinator: ApplicationCoordinator {
    
    var window: UIWindow
    var appCoordinator: Coordinator!
    var dataSource: BaseMediaControllerDataSource!
    var tabbBarCoordinator:  TabBarCoordinator!
    var itemToSave: CasterSearchResult!
    var itemIndex: Int!
    let reachability = Reachability()!
    var store = SearchResultsDataStore()
    var managedContext: NSManagedObjectContext!
    
    init(window: UIWindow) {
        self.window = window
        self.appCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
        appCoordinator.delegate = self
    }
    
    convenience init(window: UIWindow, coordinator: Coordinator) {
        self.init(window: window)
        self.appCoordinator = coordinator
        appCoordinator.delegate = self
    }
    
    func start() {
        guard let coordinator = appCoordinator else { return }
        coordinator.start()
    }
}
