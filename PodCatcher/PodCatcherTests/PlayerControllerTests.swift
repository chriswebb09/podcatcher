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
        mediaPlayer.getPlaylists { collection, list in
            guard let list = list, list.count > 0 else { return }
            self.playerViewController = PlayerViewController(index: 0, caster: list[1], user: nil)
            XCTAssertNotNil(self.playerViewController.caster)
        }
    }
    
    func testSkipButton() {
        let testDelegate = PlayerViewControllerDelegateTest()
        mediaPlayer.getPlaylists { collection, list in
            guard let list = list, list.count > 0 else { return }
            self.playerViewController = PlayerViewController(index: 0, caster: list[1], user: nil)
            XCTAssertNotNil(self.playerViewController.caster)
            self.playerViewController.delegate = testDelegate
            self.playerViewController.skipButtonTapped()
            XCTAssertEqual(self.playerViewController.index, 1)
        }
    }
    
    func testBackButton() {
        let testDelegate = PlayerViewControllerDelegateTest()
        mediaPlayer.getPlaylists { collection, list in
            guard let list = list else { return }
            guard list.count > 0 else { return }
            self.playerViewController = PlayerViewController(index: 0, caster: list[1], user: nil)
            XCTAssertNotNil(self.playerViewController.caster)
            self.playerViewController.delegate = testDelegate
            self.playerViewController.backButtonTapped()
            XCTAssertEqual(self.playerViewController.index, 0)
            self.playerViewController.skipButtonTapped()
            XCTAssertEqual(self.playerViewController.index, 1)
            self.playerViewController.backButtonTapped()
            XCTAssertEqual(self.playerViewController.index, 0)
        }
    }
}

class PlayerViewControllerDelegateTest: PlayerViewControllerDelegate {
    
    func playButtonTapped() {
        
    }
    
    func pauseButtonTapped() {
        
    }
    
    func skipButtonTapped() {
        
    }
}
