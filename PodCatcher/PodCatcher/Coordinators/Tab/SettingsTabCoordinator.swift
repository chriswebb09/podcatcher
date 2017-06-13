//
//  SettingsTabCoordinator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SettingsTabCoordinator: NavigationCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType = .tabbar
    var dataSource: BaseMediaControllerDataSource!
    
    var childViewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childViewControllers = navigationController.viewControllers
    }
    
    convenience init(navigationController: UINavigationController, controller: UIViewController) {
        self.init(navigationController: navigationController)
        navigationController.viewControllers = [controller]
    }
    
    func start() {
        let settingsViewController = navigationController.viewControllers[0] as! SettingsViewController
        settingsViewController.delegate = self
    }
}

extension SettingsTabCoordinator: SettingsViewControllerDelegate {
    
    func settingTwoTapped(tapped: Bool) {
        print("TWO TAP")
        var updateAccountView = UpdateAccountView()
        var updateAccountViewController = UpdateAccountViewController()
        updateAccountViewController.dataSource = dataSource
        navigationController.viewControllers.append(updateAccountViewController)
    }

    func settingOneTapped(tapped: Bool) {
        print("ONE TAP")
        var updateAccountView = UpdateAccountView()
        var updateAccountViewController = UpdateAccountViewController()
        updateAccountViewController.dataSource = dataSource
        navigationController.viewControllers.append(updateAccountViewController)
       // navigationController.viewControllers.append(
    }

    
}
