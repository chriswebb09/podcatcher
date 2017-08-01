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
        let startCoord = mainCoordinator.appCoordinator as? StartCoordinator
    }
    
    func testSplash() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as? StartCoordinator
        XCTAssertNotNil(startCoord?.childViewControllers[0] as? SplashViewController)
        XCTAssertNoThrow(startCoord?.childViewControllers[0] as? SplashViewController)
    }
    
    func testGoToLogin() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as? StartCoordinator
        startCoord?.skipSplash()
        XCTAssertNotNil(startCoord?.childViewControllers[1] as? StartViewController)
        XCTAssertNoThrow(startCoord?.childViewControllers[1] as? StartViewController)
        XCTAssertEqual(mainCoordinator?.appCoordinator.type, .app)
    }
    
    func testGoToCreateAccount() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as? StartCoordinator
        startCoord?.skipSplash()
        XCTAssertNotNil(startCoord?.childViewControllers[1] as? StartViewController)
        XCTAssertNoThrow(startCoord?.childViewControllers[1] as? StartViewController)
    }
}
