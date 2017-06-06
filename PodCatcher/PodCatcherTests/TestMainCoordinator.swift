import XCTest
@testable import PodCatcher

class TestMainCoordinator: XCTestCase {
    
    var mainCoordinator: MainCoordinator!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoord = StartCoordinator(navigationController: UINavigationController(), window: window)
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
    
    func testAddChild() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as! StartCoordinator
        let viewController = CreateAccountViewController()
        startCoord.addChild(viewController: viewController)
        XCTAssertNotNil(startCoord.childViewControllers[1] as! CreateAccountViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[1] as! CreateAccountViewController)
    }
    
    func testSplash() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as! StartCoordinator
        XCTAssertNotNil(startCoord.childViewControllers[0] as! SplashViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[0] as! SplashViewController)
    }
    
    func testGoToLogin() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as! StartCoordinator
        startCoord.skipSplash()
        XCTAssertNotNil(startCoord.childViewControllers[1] as! StartViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[1] as! StartViewController)
        startCoord.loginSelected()
        let loginViewController = LoginViewController()
        startCoord.addChild(viewController: loginViewController)
        XCTAssertNotNil(startCoord.childViewControllers[2] as! LoginViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[2] as! LoginViewController)
    }
    
    func testGoToCreateAccount() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as! StartCoordinator
        startCoord.skipSplash()
        XCTAssertNotNil(startCoord.childViewControllers[1] as! StartViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[1] as! StartViewController)
        startCoord.createAccountSelected()
        let createAccountViewController = CreateAccountViewController()
        startCoord.addChild(viewController: createAccountViewController)
        XCTAssertNotNil(startCoord.childViewControllers[2] as! CreateAccountViewController)
        XCTAssertNoThrow(startCoord.childViewControllers[2] as! CreateAccountViewController)
    }
}
