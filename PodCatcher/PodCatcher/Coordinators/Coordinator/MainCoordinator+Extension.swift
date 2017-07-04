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
            tabbarController.dataSource = self.dataSource
            
            let tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
            guard let dataSource = dataSource else { return }
            
            let homeViewController = HomeViewController(index: 0, dataSource: dataSource)
            
            homeViewController.dataSource.store.pullFeedTopPodcasts { data, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    homeViewController.dataSourceTwo.response = data
                    homeViewController.dataSource.response = data
                    
                }
            }

            let homeTab = UINavigationController(rootViewController: homeViewController)
            tabbBarCoordinator.setupHomeCoordinator(navigationController: homeTab, dataSource: dataSource)
            
            let mediaViewController = MediaCollectionViewController(dataSource: dataSource)
            let mediaTab = UINavigationController(rootViewController: mediaViewController)
            tabbBarCoordinator.setupMediaCoordinator(navigationController: mediaTab, dataSource: dataSource)
            let mediaCoord = tabbBarCoordinator.childCoordinators[1] as! MediaTabCoordinator
            mediaCoord.delegate = self
            
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
