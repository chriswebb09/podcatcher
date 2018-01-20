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
        setupPlaylistsTab()
        setupBrowseTab()
        setupSearchTab()
        setupSettingsTab()
        appCoordinator = tabbBarCoordinator
        appCoordinator.start()
    }
    
    func setupHomeTab() {
        let backingVC = HomeBackingViewController()
        let homeViewController = HomeViewController()
        backingVC.homeViewController = homeViewController
        let backingTab = UINavigationController(rootViewController: backingVC)
        tabbBarCoordinator.setupHomeCoordinator(navigationController: backingTab)
    
//        let homeTab = UINavigationController(rootViewController: homeViewController)
//        tabbBarCoordinator.setupHomeCoordinator(navigationController: homeTab)
        let homeCoord = tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
        homeViewController.coordinator = homeCoord
        homeCoord.delegate = self
        homeCoord.feedStore = feedStore
    }
    
    func setupPlaylistsTab() {
        let playlistsViewController = PlaylistsViewController()
        let playlistsTab = UINavigationController(rootViewController: playlistsViewController)
        tabbBarCoordinator.setupPlaylistsCoordinator(navigationController: playlistsTab)
        let playlistsCoord = tabbBarCoordinator.childCoordinators[1] as! PlaylistsTabCoordinator
        playlistsViewController.coordinator = playlistsCoord
        playlistsCoord.delegate = self
        playlistsCoord.start()
        addChildCoordinator(playlistsCoord)
    }
    
    func setupBrowseTab() {
        let browseViewController = BrowseViewController(index: 0)
        let browseTab = UINavigationController(rootViewController: browseViewController)
        tabbBarCoordinator.setupBrowseCoordinator(navigationController: browseTab)
        let browseCoord = tabbBarCoordinator.childCoordinators[2] as! BrowseTabCoordinator
        browseViewController.coordinator = browseCoord
        browseCoord.delegate = self
        browseCoord.setupBrowse()
        addChildCoordinator(browseCoord)
        browseCoord.viewDidLoad(browseViewController)
        browseCoord.feedStore = feedStore
    }
    
    func setupSearchTab() {
        let searchViewController = SearchViewController()
        let searchTab = UINavigationController(rootViewController: searchViewController)
        tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab)
        let searchCoord = tabbBarCoordinator.childCoordinators[3] as! SearchTabCoordinator
        searchCoord.delegate = self
        addChildCoordinator(searchCoord)
        searchCoord.feedStore = feedStore
    }
    
    func setupSettingsTab() {
        let settingsViewController = SettingsViewController()
        let settingsTab = UINavigationController(rootViewController: settingsViewController)
       
        tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab)
        tabbBarCoordinator.delegate = self
        let settingsCoord = tabbBarCoordinator.childCoordinators[4] as! SettingsTabCoordinator
        settingsCoord.delegate = self
        addChildCoordinator(settingsCoord)
    }
}
