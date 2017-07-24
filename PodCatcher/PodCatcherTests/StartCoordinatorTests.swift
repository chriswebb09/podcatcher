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
        startCoordinator.splashAnimation(finished: true)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertNotNil(navigationController.viewControllers[1] as! StartViewController)
    }
    
    func testGoToLogin() {
        startCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        startCoordinator.splashAnimation(finished: true)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertNotNil(navigationController.viewControllers[1] as! StartViewController)
    }
    
    func testGoToCreateAccount() {
        startCoordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        startCoordinator.splashAnimation(finished: true)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertNotNil(navigationController.viewControllers[1] as! StartViewController)
    }
}
