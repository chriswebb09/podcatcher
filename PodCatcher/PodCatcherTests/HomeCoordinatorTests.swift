import XCTest
@testable import PodCatcher

class HomeCoordinatorTests: XCTestCase {
    
    var homeCoordinator: HomeTabCoordinator!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        homeCoordinator = nil
        super.tearDown()
    }
}
