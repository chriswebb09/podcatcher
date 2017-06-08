//
//  PodcastsListTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

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
