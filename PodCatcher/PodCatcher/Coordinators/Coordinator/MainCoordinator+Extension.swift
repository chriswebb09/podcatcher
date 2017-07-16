import UIKit
import Firebase

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
        switch type {
        case .app:
            let firebaseAuth = Auth.auth()
            
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            let newCoordinator = StartCoordinator(navigationController: UINavigationController(), window: window)
            newCoordinator.delegate = self
            newCoordinator.skipSplash()
            self.appCoordinator = newCoordinator
            self.appCoordinator.delegate = self
            
        case .tabbar:
            let tabbarController = TabBarController()
            self.dataSource = dataSource
            if let user = dataSource?.user {
                user.customGenres = ["Test one", "test two"]
            }
            var getData = false
            tabbarController.dataSource = self.dataSource
            self.tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
            guard let dataSource = dataSource else { return }
            let homeViewController = HomeViewController(dataSource: dataSource)
            getData = UserDefaults.loadOnAuth()
            
            let homeTab = UINavigationController(rootViewController: homeViewController)
            tabbBarCoordinator.setupHomeCoordinator(navigationController: homeTab, dataSource: dataSource)
            let homeCoord = tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
            homeCoord.delegate = self
            let playlistsViewController = PlaylistsViewController()
            let playlistsTab = UINavigationController(rootViewController: playlistsViewController)
            tabbBarCoordinator.setupPlaylistsCoordinator(navigationController: playlistsTab, dataSource: dataSource)
            let playlistsCoord = tabbBarCoordinator.childCoordinators[1] as! PlaylistsTabCoordinator
            
            playlistsCoord.delegate = self
            playlistsCoord.setup()
            
            let browseViewController = BrowseViewController(index: 0, dataSource: dataSource)
            let browseTab = UINavigationController(rootViewController: browseViewController)
            tabbBarCoordinator.setupBrowseCoordinator(navigationController: browseTab, dataSource: dataSource)
            let browseCoord = tabbBarCoordinator.childCoordinators[2] as! BrowseTabCoordinator
            browseCoord.delegate = self
            browseCoord.setupBrowse()
            
            let searchViewController = SearchViewController()
            let searchTab = UINavigationController(rootViewController: searchViewController)
            tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab, dataSource: dataSource)
            let searchCoord = tabbBarCoordinator.childCoordinators[3] as! SearchTabCoordinator
            searchCoord.delegate = self
            
            let settingsViewController = SettingsViewController()
            let settingsTab = UINavigationController(rootViewController: settingsViewController)
            
            tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource)
            tabbBarCoordinator.delegate = self
            let settingsCoord = tabbBarCoordinator.childCoordinators[4] as! SettingsTabCoordinator
            settingsCoord.delegate = self
            appCoordinator = tabbBarCoordinator
            start()
        }
    }
}
