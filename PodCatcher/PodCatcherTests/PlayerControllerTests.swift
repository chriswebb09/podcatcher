//
//  PlayerControllerTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import PodCatcher

class PlayerControllerTests: XCTestCase {
    
     var mediaPlayer: PCMediaPlayer!
    
    override func setUp() {
        super.setUp()
        mediaPlayer = PCMediaPlayer()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        mediaPlayer = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPlayerController() {
        mediaPlayer.getPlaylists { collection, list in
            var controller = PlayerViewController(index: 0, caster: list![1])
            XCTAssertNotNil(controller.caster)
        }
        
    }
    
    
}
