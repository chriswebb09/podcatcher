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
    let fetcher = PCMediaPlayer()
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
        
        fetcher.getPlaylists { [weak self] casts, lists in
            if let strongSelf = self, let lists = lists {
                let listSet = Set(lists)
                DispatchQueue.main.async {
                    strongSelf.dataSource = BaseMediaControllerDataSource(casters: Array(listSet))
                }
            }
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

extension StartCoordinator: SplashViewControllerDelegate {
    
    func splashViewFinishedAnimation(finished: Bool) {
        let startViewController = StartViewController()
        startViewController.delegate = self
        addChild(viewController: startViewController)
    }
}

extension StartCoordinator: StartViewControllerDelegate {
    
    func loginSelected() {
        let loginView = LoginView()
        let loginModel = LoginViewModel()
        loginView.configure(model: loginModel)
        let loginViewController = LoginViewController(loginView: loginView)
        loginViewController.delegate = self
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func createAccountSelected() {
        let createAccountViewController = CreateAccountViewController()
        createAccountViewController.delegate = self
        navigationController.pushViewController(createAccountViewController, animated: false)
    }
    
    func continueAsGuestSelected() {
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
    }
}

extension StartCoordinator: LoginViewControllerDelegate {
    
    func successfulLogin(for user: PodCatcherUser) {
        if dataSource.casters.count < 0 {
            let newDataSource = BaseMediaControllerDataSource(casters: user.casts)
            self.dataSource = newDataSource
        }
        user.casts = dataSource.casters
        dataSource.user = user
        delegate?.transitionCoordinator(type: .tabbar, dataSource: self.dataSource)
    }
}

extension StartCoordinator: CreateAccountViewControllerDelegate {
    
    func submitButtonTapped() {
        print("tap")
        delegate?.transitionCoordinator(type: .tabbar, dataSource: dataSource)
        
    }
}
