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
    
    
    func testSubmitButtonEnabled() {
        let textField = UITextField()
        let loginViewModel = LoginViewModel()
        textField.text = "hello@gmail.com"
        loginView.model = loginViewModel
        loginView.textFieldDidEndEditing(textField)
        XCTAssertTrue(loginView.model.submitEnabled)
    }
    
    
    func testSubmitButtonTapped() {
        let loginTest = LoginTestDelegate()
        loginViewController.delegate = loginTest
        loginViewController.submitButtonTapped()
    }

}

class LoginTestDelegate: LoginViewControllerDelegate {
    func loginButtonTapped(tapped: Bool) {
        XCTAssertTrue(tapped)
    }
}
