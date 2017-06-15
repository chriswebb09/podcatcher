import XCTest
@testable import PodCatcher

class PodcastsListTests: XCTestCase {
    
    var podcastsListViewController: PodcastListViewController!
    
    override func setUp() {
        super.setUp()
        var caster = Caster()
        caster.name = "Test Name"
        var dataSource = BaseMediaControllerDataSource(casters: [caster])
        podcastsListViewController = PodcastListViewController(index: 0, dataSource: dataSource)
    }
    
    override func tearDown() {
        podcastsListViewController = nil
        super.tearDown()
    }
    
}
