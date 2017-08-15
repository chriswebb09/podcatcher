import UIKit
import ReachabilitySwift
import CoreData

class MainCoordinator: ApplicationCoordinator {
   
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var appCoordinator: Coordinator
    var dataSource: BaseMediaControllerDataSource!
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
        appCoordinator.start()
    }
}

extension MainCoordinator: CoordinatorDelegate {
    
    func addItemToPlaylist(podcastPlaylist: PodcastPlaylist) {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
            //fatalError("Failure to save context: \(error)")
        }
    }

    
    func podcastItem(toAdd: CasterSearchResult, with index: Int) {
        itemToSave = toAdd
        itemIndex = index
    }
    
    func updatePodcast(with playlistId: String) {
        
    }
    
    func transitionCoordinator(type: CoordinatorType, dataSource: BaseMediaControllerDataSource?) {
        switch type {
        case .app:
            let newCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
            newCoordinator.delegate = self
            newCoordinator.skipSplash()
            appCoordinator = newCoordinator
            appCoordinator.delegate = self
        case .tabbar:
            setupTabCoordinator(dataSource: dataSource)
        }
    }
    
    func setupTabCoordinator(dataSource: BaseMediaControllerDataSource?) {
        let tabbarController = TabBarController()
        self.dataSource = dataSource
        tabbarController.dataSource = self.dataSource
        self.tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
        setupHomeTab()
        setupPlaylistsTab()
        setupBrowseTab()
        setupSearchTab()
        setupSettingsTab()
        appCoordinator = tabbBarCoordinator
        start()
    }
    
    func setupHomeTab() {
        let homeViewController = HomeViewController(dataSource: dataSource)
        let homeTab = UINavigationController(rootViewController: homeViewController)
        tabbBarCoordinator.setupHomeCoordinator(navigationController: homeTab, dataSource: dataSource)
        let homeCoord = tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
        homeViewController.coordinator = homeCoord
        homeCoord.delegate = self
    }
    
    func setupPlaylistsTab() {
        let playlistsViewController = PlaylistsViewController()
        let playlistsTab = UINavigationController(rootViewController: playlistsViewController)
        tabbBarCoordinator.setupPlaylistsCoordinator(navigationController: playlistsTab, dataSource: dataSource)
        let playlistsCoord = tabbBarCoordinator.childCoordinators[1] as! PlaylistsTabCoordinator
        playlistsViewController.coordinator = playlistsCoord
        playlistsCoord.delegate = self
        playlistsCoord.setup()
        addChildCoordinator(playlistsCoord)
    }
    
    func setupBrowseTab() {
        let browseViewController = BrowseViewController(index: 0, dataSource: dataSource)
        let browseTab = UINavigationController(rootViewController: browseViewController)
        tabbBarCoordinator.setupBrowseCoordinator(navigationController: browseTab, dataSource: dataSource)
        let browseCoord = tabbBarCoordinator.childCoordinators[2] as! BrowseTabCoordinator
        browseViewController.coordinator = browseCoord
        browseCoord.delegate = self
        browseCoord.setupBrowse()
        addChildCoordinator(browseCoord)
    }
    
    func setupSearchTab() {
        let searchViewController = SearchViewController()
        let searchTab = UINavigationController(rootViewController: searchViewController)
        tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab, dataSource: dataSource)
        let searchCoord = tabbBarCoordinator.childCoordinators[3] as! SearchTabCoordinator
        searchCoord.delegate = self
        addChildCoordinator(searchCoord)
    }
    
    func setupSettingsTab() {
        let settingsViewController = SettingsViewController()
        let settingsTab = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.dataSource = dataSource
        tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource)
        tabbBarCoordinator.delegate = self
        let settingsCoord = tabbBarCoordinator.childCoordinators[4] as! SettingsTabCoordinator
        settingsCoord.delegate = self
        addChildCoordinator(settingsCoord)
    }
}
