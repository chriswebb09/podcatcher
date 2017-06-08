import XCTest
@testable import PodCatcher

class PodcastsListTests: XCTestCase {
    
    var podcastsListViewController: PodcastListViewController!
    
    override func setUp() {
        super.setUp()
        podcastsListViewController = PodcastListViewController()
    }
    
    override func tearDown() {
        podcastsListViewController = nil
        super.tearDown()
    }
    
    func testSetCaster() {
        var caster = Caster()
        caster.name = "Test Name"
        let dataSource = BaseMediaControllerDataSource(casters: [caster])
        podcastsListViewController.caster = caster
        podcastsListViewController.dataSource = dataSource
        podcastsListViewController.viewDidLoad()
        XCTAssertEqual(podcastsListViewController.title, "Test Name")
    }
    
}
