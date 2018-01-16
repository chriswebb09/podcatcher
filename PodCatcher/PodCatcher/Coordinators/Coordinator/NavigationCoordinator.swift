//
//  NavigationCoordinator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/4/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}
