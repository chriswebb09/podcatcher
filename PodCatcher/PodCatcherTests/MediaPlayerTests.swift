//
//  MediaPlayerTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import PodCatcher

class MediaPlayerTests: XCTestCase {
    
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
    
    func testMediaPlayerGetItems() {
        mediaPlayer.getPlaylists { items, list in
            XCTAssertNotNil(list)
        }
    }
}
