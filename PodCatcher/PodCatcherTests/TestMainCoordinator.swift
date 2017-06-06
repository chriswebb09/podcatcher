//
//  TestMainCoordinator.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import PodCatcher

class TestMainCoordinator: XCTestCase {
    
    var mainCoordinator: MainCoordinator!
    
    override func setUp() {
        super.setUp()
        var window = UIWindow(frame: UIScreen.main.bounds)
        var appCoord = StartCoordinator(navigationController: UINavigationController(), window: window)
        mainCoordinator = MainCoordinator(window: UIWindow(frame: UIScreen.main.bounds), coordinator: appCoord)
    }
    
    override func tearDown() {
        mainCoordinator = nil
        super.tearDown()
    }
    
    func testStart() {
        mainCoordinator.start()
        XCTAssertEqual(mainCoordinator.appCoordinator.type, .app)
    }
    
    func testSplash() {
        mainCoordinator.start()
        var startCoord = mainCoordinator.appCoordinator as! StartCoordinator
        XCTAssertNotNil(startCoord.childViewControllers[0] as! SplashViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[0] as! SplashViewController)
    }
}
