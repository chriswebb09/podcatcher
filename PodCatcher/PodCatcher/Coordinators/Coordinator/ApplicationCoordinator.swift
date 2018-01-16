//
//  ApplicationCoordinator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/4/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ApplicationCoordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var appCoordinator: Coordinator { get set }
    var window: UIWindow { get set }
    func start()
}

extension ApplicationCoordinator {
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}
