import UIKit
import Reachability
import CoreData

class MainCoordinator: ApplicationCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    let feedStore = FeedCoreDataStack()
    var appCoordinator: Coordinator
    
    var tabbBarCoordinator:  TabBarCoordinator!
    var itemToSave: CasterSearchResult!
    var itemIndex: Int!
    let reachability = Reachability()!
    var store = SearchResultsDataStore()
    var audioPlayer = AudioFilePlayer()
    var managedContext: NSManagedObjectContext!
    
    init(window: UIWindow) {
        self.window = window
        appCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
        appCoordinator.delegate = self
    }
    
    convenience init(window: UIWindow, coordinator: Coordinator) {
        self.init(window: window)
        appCoordinator = coordinator
        appCoordinator.delegate = self
    }
    
    func start() {
        if UserDefaults.loadDefaultOnFirstLaunch() {
            appCoordinator.start()
            setupTabCoordinator()
        } else {
            transitionCoordinator(type: .app)
        }
    }
}

extension MainCoordinator: CoordinatorDelegate {
    
    func addItemToPlaylist(podcastPlaylist: PodcastPlaylist) {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func podcastItem(toAdd: CasterSearchResult, with index: Int) {
        itemToSave = toAdd
        itemIndex = index
    }
    
    func updatePodcast(with playlistId: String) {
        
    }
    
    func transitionCoordinator(type: CoordinatorType) {
        switch type {
        case .app:
            let newCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
            newCoordinator.delegate = self
            newCoordinator.skipSplash()
            appCoordinator = newCoordinator
            appCoordinator.delegate = self
        case .tabbar:
            setupTabCoordinator()
        }
    }
    
    func setupTabCoordinator() {
        let tabbarController = TabBarController()
        self.tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
        setupHomeTab()
        setupSearchTab()
        setupSettingsTab()
        appCoordinator = tabbBarCoordinator
        appCoordinator.start()
    }
    
    func setupHomeTab() {
        let homeBackingVC = HomeBackingViewController()
        let homeViewController = HomeViewController()
        homeBackingVC.homeViewController = homeViewController
        let backingTab = UINavigationController(rootViewController: homeBackingVC)
        tabbBarCoordinator.setupHomeCoordinator(navigationController: backingTab)
        let homeCoord = tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
        homeViewController.coordinator = homeCoord
        homeCoord.delegate = self
        homeCoord.feedStore = feedStore
    }
    
    func setupSearchTab() {
        let searchViewController = SearchViewController()
        let searchTab = UINavigationController(rootViewController: searchViewController)
        tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab)
        let searchCoord = tabbBarCoordinator.childCoordinators[1] as! SearchTabCoordinator
        searchCoord.delegate = self
        addChildCoordinator(searchCoord)
        searchCoord.feedStore = feedStore
    }
    
    func setupSettingsTab() {
        let settingsViewController = SettingsViewController()
        let settingsTab = UINavigationController(rootViewController: settingsViewController)
        tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab)
        tabbBarCoordinator.delegate = self
        let settingsCoord = tabbBarCoordinator.childCoordinators[2] as! SettingsTabCoordinator
        settingsCoord.delegate = self
        addChildCoordinator(settingsCoord)
    }
}
