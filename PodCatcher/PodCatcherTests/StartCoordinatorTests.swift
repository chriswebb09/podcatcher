import XCTest
@testable import PodCatcher

class StartCoordinatorTests: XCTestCase {
    
    var window: UIWindow!
    var startCoordinator: StartCoordinator!
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController()
        startCoordinator = StartCoordinator(navigationController: navigationController, window: window)
    }
    
    override func tearDown() {
        super.tearDown()
        window = nil
        navigationController = nil
        startCoordinator = nil
    }
    
    func testStartSplash() {
        startCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    func testGoToStart() {
        startCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        startCoordinator.splashViewFinishedAnimation(finished: true)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertNotNil(navigationController.viewControllers[1] as! StartViewController)
    }
    
    func testGoToLogin() {
        startCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        startCoordinator.splashViewFinishedAnimation(finished: true)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertNotNil(navigationController.viewControllers[1] as! StartViewController)
        startCoordinator.loginSelected()
        XCTAssertNotNil(navigationController.viewControllers[2] as! LoginViewController)
    }
    
    func testGoToCreateAccount() {
        startCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        startCoordinator.splashViewFinishedAnimation(finished: true)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertNotNil(navigationController.viewControllers[1] as! StartViewController)
        startCoordinator.createAccountSelected()
        XCTAssertNotNil(navigationController.viewControllers[2] as! CreateAccountViewController)
    }
}
