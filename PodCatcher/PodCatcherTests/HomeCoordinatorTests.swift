import XCTest
@testable import PodCatcher

class HomeCoordinatorTests: XCTestCase {
    
    var homeCoordinator: HomeTabCoordinator!
    
    override func setUp() {
        let homeViewController = HomeViewController(collectionView: UICollectionView(), dataSource: BaseMediaControllerDataSource())
        homeCoordinator = HomeTabCoordinator(navigationController: UINavigationController(rootViewController: homeViewController))
        super.setUp()
    }
    
    override func tearDown() {
        homeCoordinator = nil
        super.tearDown()
    }
    
    func testBackingViewController() {
        homeCoordinator.start()
        XCTAssertNotNil(homeCoordinator.navigationController.viewControllers[0] as? HomeBackingViewController)
    }
}
