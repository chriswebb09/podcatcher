import UIKit
import Firebase

class MainCoordinator: ApplicationCoordinator {
    
    var window: UIWindow
    var appCoordinator: Coordinator!
    var dataSource: BaseMediaControllerDataSource!
    
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
            tabbarController.dataSource = self.dataSource
            
            let tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
            guard let dataSource = dataSource else { return }
            
            let mediaViewController = MediaCollectionViewController(dataSource: dataSource)
            let mediaTab = UINavigationController(rootViewController: mediaViewController)
            tabbBarCoordinator.setupMediaCoordinator(navigationController: mediaTab, dataSource: dataSource)
            let mediaCoord = tabbBarCoordinator.childCoordinators[0] as! MediaTabCoordinator
            mediaCoord.delegate = self
            
            let model = SettingsViewModel(firstSettingOptionText: "OptionOne", secondSettingOptionText: "OptionTwo")
            let settingsView = SettingsView(frame: CGRect.zero, model: model)
            let settingsViewController = SettingsViewController(settingsView: settingsView, dataSource: dataSource)
            let settingsTab = UINavigationController(rootViewController: settingsViewController)
            //let settingsCoord = tabbBarCoordinator.childCoordinators[1] as! SettingsViewControllerDelegate
           // settingsCoord.
            
            tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource)
            tabbBarCoordinator.delegate = self
            
            appCoordinator = tabbBarCoordinator
            start()
        }
    }
}

