import UIKit

class MainCoordinator: ApplicationCoordinator {
    
    var window: UIWindow
    var appCoordinator: Coordinator!
    
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
            break
        case .tabbar:
            let tabbarController = TabBarController()
            tabbarController.dataSource = dataSource
            
            let tabbBarCoordinator = TabBarCoordinator(tabBarController: tabbarController, window: window)
            let mediaViewController = MediaCollectionViewController(dataSource: dataSource!)
            let mediaTab = UINavigationController(rootViewController: mediaViewController)
            tabbBarCoordinator.setupMediaCoordinator(navigationController: mediaTab, dataSource: dataSource!)
            
            var splashViewController = SplashViewController()
            let settingsTab = UINavigationController(rootViewController: SplashViewController())
            tabbBarCoordinator.setupSettingsCoordinator(navigationController: settingsTab, dataSource: dataSource!)
            tabbBarCoordinator.delegate = self
            
            appCoordinator = tabbBarCoordinator
            start()
        }
    }
}

