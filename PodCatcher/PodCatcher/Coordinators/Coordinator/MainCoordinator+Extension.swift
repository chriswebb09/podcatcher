import UIKit
import Firebase

extension MainCoordinator: CoordinatorDelegate {
    
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
            let tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
            guard let dataSource = dataSource else { return }
            let homeViewController = HomeViewController(index: 0, dataSource: dataSource)
            getData = UserDefaults.loadOnAuth()
            
            if getData == true || UserDefaults.loadDefaultOnFirstLaunch() == true {
                homeViewController.dataSource.store.pullFeedTopPodcasts { data, error in
                    UserDefaults.standard.set(Date(), forKey: "topItems")
                    guard let data = data else { return }
                    for item in data {
                        homeViewController.dataSource.lookup = item.id
                        homeViewController.dataSource.fetcher.searchForTracksFromLookup { result in
                            guard let result = result.0 else { return }
                            DispatchQueue.main.async {
                                homeViewController.dataSource.reserveItems.append(contentsOf: result)
                                homeViewController.dataSource.items.append(contentsOf: result)
                                homeViewController.collectionView.reloadData()
                                guard let urlString = homeViewController.dataSource.reserveItems[homeViewController.dataSource.topViewItemIndex].podcastArtUrlString else { return }
                                guard let imageUrl = URL(string: urlString) else { return }
                                homeViewController.topView.podcastImageView.downloadImage(url: imageUrl)
                            }
                            result.map { homeViewController.dataSource.topStore.save(podcastItem: $0) }
                        }
                    }
                }
            } else {
                homeViewController.dataSource.dataType = .local
            }
            
            let homeTab = UINavigationController(rootViewController: homeViewController)
            tabbBarCoordinator.setupHomeCoordinator(navigationController: homeTab, dataSource: dataSource)
            
            let homeCoord = tabbBarCoordinator.childCoordinators[0] as! HomeTabCoordinator
            homeCoord.delegate = self
            
            let playlistsViewController = PlaylistsViewController()
            let playlistsTab = UINavigationController(rootViewController: playlistsViewController)
            tabbBarCoordinator.setupPlaylistsCoordinator(navigationController: playlistsTab, dataSource: dataSource)
            let playlistsCoord = tabbBarCoordinator.childCoordinators[1] as! PlaylistsTabCoordinator
            playlistsCoord.delegate = self
            
            let searchViewController = SearchViewController()
            
            let searchTab = UINavigationController(rootViewController: searchViewController)
            tabbBarCoordinator.setupSearchCoordinator(navigationController: searchTab, dataSource: dataSource)
            let searchCoord = tabbBarCoordinator.childCoordinators[2] as! SearchTabCoordinator
            searchCoord.delegate = self
            
            let model = SettingsViewModel(firstSettingOptionText: "OptionOne", secondSettingOptionText: "OptionTwo")
            let settingsView = SettingsView(frame: CGRect.zero, model: model)
            let settingsViewController = SettingsViewController(settingsView: settingsView, dataSource: dataSource)
            let settingsTab = UINavigationController(rootViewController: settingsViewController)
            
            tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource)
            tabbBarCoordinator.delegate = self
            let settingsCoord = tabbBarCoordinator.childCoordinators[3] as! SettingsTabCoordinator
            settingsCoord.delegate = self
            
            appCoordinator = tabbBarCoordinator
            start()
        }
    }
}
