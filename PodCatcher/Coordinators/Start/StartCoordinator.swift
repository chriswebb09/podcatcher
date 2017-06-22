//
//  StartCoordinator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class StartCoordinator: NavigationCoordinator {
    
    var type: CoordinatorType = .app
    weak var delegate: CoordinatorDelegate?
    var window: UIWindow!
    var dataSource: BaseMediaControllerDataSource!
    var store = PodcatcherDataStore()
    var childViewControllers: [UIViewController] = []
    
    var navigationController: UINavigationController {
        didSet {
            childViewControllers = navigationController.viewControllers
        }
    }
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, window: UIWindow) {
        self.init(navigationController: navigationController)
        self.window = window
        store.pullPodcastsFromUser { list in
            self.dataSource =  BaseMediaControllerDataSource(casters: list)
        }
    }
    
    func start() {
        guard let window = window else { fatalError("Window object not created") }
        let splashViewController = SplashViewController()
        splashViewController.delegate = self
        addChild(viewController: splashViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func skipSplash() {
        guard let window = window else { fatalError("Window object not created") }
        let startViewController = StartViewController()
        startViewController.delegate = self
        addChild(viewController: startViewController)
        window.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        window.makeKeyAndVisible()
    }
    
    func addChild(viewController: UIViewController) {
        childViewControllers.append(viewController)
        navigationController.viewControllers = childViewControllers
    }
}

