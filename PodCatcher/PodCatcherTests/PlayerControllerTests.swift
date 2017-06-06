import XCTest
@testable import PodCatcher

class PlayerControllerTests: XCTestCase {
    
     var mediaPlayer: PCMediaPlayer!
    
    override func setUp() {
        super.setUp()
        mediaPlayer = PCMediaPlayer()
    }
    
    override func tearDown() {
        mediaPlayer = nil
        super.tearDown()
    }
    
    func testPlayerController() {
        mediaPlayer.getPlaylists { collection, list in
            let controller = PlayerViewController(index: 0, caster: list![1])
            XCTAssertNotNil(controller.caster)
        }
    }
}
