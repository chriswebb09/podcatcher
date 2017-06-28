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
        mediaPlayer.getPlaylists { list in
            XCTAssertNotNil(list)
        }
    }
    
    func testConstructTimeString() {
        var time = String.constructTimeString(time: 869.844)
        XCTAssertEqual(time, "14:29")
        time = String.constructTimeString(time: 0.0)
        XCTAssertEqual(time, "0:00")
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
