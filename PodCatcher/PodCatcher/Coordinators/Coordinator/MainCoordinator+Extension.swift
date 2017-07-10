import UIKit
import Firebase

import CoreData

class PlaylistItemsCoreDataStack {
    
    var playlists: [NSManagedObject] = []
    
//    func fetchFromCore() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.coreData.managedContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PodcastPlaylistItem")
//        do {
//            playlists = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
}

extension MainCoordinator: CoordinatorDelegate {
    
//    func getViewController(from type: TabType) -> UIViewController {
//        switch type {
//        case .home:
//            var homeTab = self.tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
//            var nav = homeTab.childViewControllers[0] as! HomeViewController
//            
//        case .player:
//            print("player")
//        case .playlist:
//            print("playlist")
//        case .playlists:
//            print("playlists")
//        case .results:
//            print("results")
//        case .search:
//            print("search")
//        }
//        return UIViewController()
//    }
//    
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
                let podcastArtImageData = UIImageJPEGRepresentation(image, 1) as? Data
                newItem.artwork = podcastArtImageData as! NSData
            }
        }

        do {
            try managedContext.save()
        } catch {
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
            let items = PlaylistItemsCoreDataStack()
            let tabbarController = TabBarController()
            self.dataSource = dataSource
            if let user = dataSource?.user {
                user.customGenres = ["Test one", "test two"]
            }
            
            var getData = false
            
            tabbarController.dataSource = self.dataSource
            self.tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
            guard let dataSource = dataSource else { return }
            let homeViewController = HomeViewController(index: 0, dataSource: dataSource)
            getData = UserDefaults.loadOnAuth()

            homeViewController.dataSource.dataType = .network
            let homeTab = UINavigationController(rootViewController: homeViewController)
            tabbBarCoordinator.setupHomeCoordinator(navigationController: homeTab, dataSource: dataSource)
            let homeCoord = tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
            homeCoord.delegate = self
            homeCoord.setup()
            
            let playlistsViewController = PlaylistsViewController()
            let playlistsTab = UINavigationController(rootViewController: playlistsViewController)
            tabbBarCoordinator.setupPlaylistsCoordinator(navigationController: playlistsTab, dataSource: dataSource)
            let playlistsCoord = tabbBarCoordinator.childCoordinators[1] as! PlaylistsTabCoordinator
            playlistsCoord.delegate = self
            playlistsCoord.setup()
            
            let searchViewController = SearchViewController()
            let searchTab = UINavigationController(rootViewController: searchViewController)
            tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab, dataSource: dataSource)
            let searchCoord = tabbBarCoordinator.childCoordinators[2] as! SearchTabCoordinator
            searchCoord.delegate = self
            
            let model = SettingsViewModel(firstSettingOptionText: "OptionOne", secondSettingOptionText: "OptionTwo")
            let settingsView = SettingsView(frame: CGRect.zero, model: model)
            let settingsViewController = SettingsViewController()
            let settingsTab = UINavigationController(rootViewController: settingsViewController)
            
            homeViewController.currentPlaylistId = playlistsViewController.currentPlaylistID
            tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource)
            tabbBarCoordinator.delegate = self
            let settingsCoord = tabbBarCoordinator.childCoordinators[3] as! SettingsTabCoordinator
            settingsCoord.delegate = self
            appCoordinator = tabbBarCoordinator
            start()
        }
    }
    
}
