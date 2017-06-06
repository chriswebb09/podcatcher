import XCTest
@testable import PodCatcher

class MediaPlayerTests: XCTestCase {
    
    var mediaPlayer: PCMediaPlayer!
    
    override func setUp() {
        super.setUp()
        mediaPlayer = PCMediaPlayer()
    }
    
    override func tearDown() {
        mediaPlayer = nil
        super.tearDown()
    }
    
    func testMediaPlayerGetItems() {
        mediaPlayer.getPlaylists { items, list in
            XCTAssertNotNil(list)
        }
    }
    
    func testValidEmail() {
        var email = "chris.webb@gmail.com"
        XCTAssertTrue(email.isValidEmail())
        email = ""
        XCTAssertFalse(email.isValidEmail())
        email = "chris.webbb@gmail"
        XCTAssertFalse(email.isValidEmail())
        email = "chris.com"
        XCTAssertFalse(email.isValidEmail())
    }
}
