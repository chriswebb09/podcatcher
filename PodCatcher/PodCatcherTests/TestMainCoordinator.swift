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
        XCTAssertEqual(mainCoordinator.appCoordinator.type, .tabbar)
    }
    
    func testAddChild() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as? StartCoordinator
    }
    
    func testSplash() {
        mainCoordinator.start()
        let startCoord = mainCoordinator.appCoordinator as? StartCoordinator
        XCTAssertNil(startCoord)
    }
}
