import UIKit
import ReachabilitySwift

extension MainCoordinator: CoordinatorDelegate {
    
    func podcastItem(toAdd: CasterSearchResult, with index: Int) {
        self.itemToSave = toAdd
        self.itemIndex = index
    }
    
    func updatePodcast(with playlistId: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.coreData.managedContext
        let newItem = PodcastPlaylistItem(context: managedContext)
        guard let audio = itemToSave.episodes[itemIndex].audioUrlString,
            let id = itemToSave.id,
            let artUrl = itemToSave.podcastArtUrlString,
            let feed = itemToSave.feedUrl
            else { return }
        newItem.audioUrl = audio
        newItem.artworkUrl = artUrl
        newItem.artistId = id
        newItem.episodeTitle = itemToSave.episodes[itemIndex].title
        newItem.episodeDescription = itemToSave.episodes[itemIndex].description
        newItem.stringDate = String(describing:itemToSave.episodes[itemIndex].date)
        newItem.playlistId = playlistId
        newItem.artistName = itemToSave.podcastArtist
        newItem.artistFeedUrl = feed
        if let urlString = itemToSave.podcastArtUrlString, let url = URL(string: urlString) {
            UIImage.downloadImage(url: url) { image in
                let podcastArtImageData = UIImageJPEGRepresentation(image, 1)
                newItem.artwork = podcastArtImageData as? NSData
            }
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func transitionCoordinator(type: CoordinatorType, dataSource: BaseMediaControllerDataSource?) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        switch type {
        case .app:
            
            let newCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
            newCoordinator.delegate = self
            newCoordinator.skipSplash()
            self.appCoordinator = newCoordinator
            self.appCoordinator.delegate = self
            
        case .tabbar:
            setupTabCoordinator(dataSource: dataSource)
        }
    }
    
    func setupTabCoordinator(dataSource: BaseMediaControllerDataSource?) {
        let tabbarController = TabBarController()
        self.dataSource = dataSource
        tabbarController.dataSource = self.dataSource
        self.tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
        guard let dataSource = dataSource else { return }
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
        homeCoord.delegate = self
    }
    
    func setupPlaylistsTab() {
        let playlistsViewController = PlaylistsViewController()
        let playlistsTab = UINavigationController(rootViewController: playlistsViewController)
        tabbBarCoordinator.setupPlaylistsCoordinator(navigationController: playlistsTab, dataSource: dataSource)
        let playlistsCoord = tabbBarCoordinator.childCoordinators[1] as! PlaylistsTabCoordinator
        
        playlistsCoord.delegate = self
        playlistsCoord.setup()
    }
    
    func setupBrowseTab() {
        let browseViewController = BrowseViewController(index: 0, dataSource: dataSource)
        let browseTab = UINavigationController(rootViewController: browseViewController)
        tabbBarCoordinator.setupBrowseCoordinator(navigationController: browseTab, dataSource: dataSource)
        let browseCoord = tabbBarCoordinator.childCoordinators[2] as! BrowseTabCoordinator
        browseCoord.delegate = self
        browseCoord.setupBrowse()
    }
    
    func setupSearchTab() {
        let searchViewController = SearchViewController()
        let searchTab = UINavigationController(rootViewController: searchViewController)
        tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab, dataSource: dataSource)
        let searchCoord = tabbBarCoordinator.childCoordinators[3] as! SearchTabCoordinator
        searchCoord.delegate = self
    }
    
    func setupSettingsTab() {
        let settingsViewController = SettingsViewController()
        let settingsTab = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.dataSource = dataSource
        tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource)
        tabbBarCoordinator.delegate = self
        let settingsCoord = tabbBarCoordinator.childCoordinators[4] as! SettingsTabCoordinator
        settingsCoord.delegate = self
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else { return }
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }
    
}
