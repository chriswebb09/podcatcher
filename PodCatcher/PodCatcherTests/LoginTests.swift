//
//  LoginTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import PodCatcher

class LoginTests: XCTestCase {
    
    var loginView: LoginView!
    var loginViewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        loginView = LoginView()
        loginViewController = LoginViewController()
    }
    
    override func tearDown() {
        loginView = nil
        loginViewController = nil
        super.tearDown()
    }
    
    func testGoToLogin() {
        let appCoordinator = StartCoordinator(navigationController: UINavigationController(rootViewController: loginViewController))
        appCoordinator.window = UIWindow(frame: UIScreen.main.bounds)
        let dataSource = BaseMediaControllerDataSource(casters: [Caster]())
        appCoordinator.dataSource = dataSource
        appCoordinator.addChild(viewController: loginViewController)
        XCTAssert(appCoordinator.childViewControllers[0] == loginViewController)
    }
}
