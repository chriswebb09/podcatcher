import XCTest
@testable import PodCatcher

class HomeCoordinatorTests: XCTestCase {
    
    var homeCoordinator: HomeTabCoordinator!
    
    override func setUp() {
        super.setUp()
        homeCoordinator = HomeTabCoordinator(navigationController: UINavigationController(rootViewController: HomeViewController(dataSource: BaseMediaControllerDataSource())))
    }
    
    override func tearDown() {
        homeCoordinator = nil
        super.tearDown()
    }
}
