import XCTest
@testable import PodCatcher

class PlayerControllerTests: XCTestCase {
    
    var mediaPlayer: PCMediaPlayer!
    var playerViewController: PlayerViewController!
    
    override func setUp() {
        super.setUp()
        mediaPlayer = PCMediaPlayer()
    }
    
    override func tearDown() {
        mediaPlayer = nil
        playerViewController = nil
        super.tearDown()
    }
    
    func testPlayerController() {
        mediaPlayer.getPlaylists { collection in
          
        }
    }
    
    func testSkipButton() {
        let testDelegate = PlayerViewControllerDelegateTest()
        mediaPlayer.getPlaylists { collection in

        }
    }
    
    func testBackButton() {
        let testDelegate = PlayerViewControllerDelegateTest()
        mediaPlayer.getPlaylists { collection in

        }
    }
}

class PlayerViewControllerDelegateTest: PlayerViewControllerDelegate {
    
    func playButton(tapped: Bool) {
        
    }
    
    func pauseButton(tapped: Bool) {
        
    }
    
    func skipButton(tapped: Bool) {
        
    }
}
