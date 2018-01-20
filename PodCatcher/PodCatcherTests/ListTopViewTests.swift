//
//  ListTopViewTests.swift
//  PodCatcherTests
//
//  Created by Christopher Webb-Orenstein on 1/18/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import PodCatcher

class ListTopViewTests: XCTestCase {
    
    var listTopView: ListTopView!
    var listTopViewDelegate: TopViewDelegate!
    
    override func setUp() {
        super.setUp()
        listTopView = ListTopView()
        listTopViewDelegate = SearchResultListViewController(index: 0)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        listTopViewDelegate = nil
        listTopView = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMoreButton() {
        listTopView.delegate = listTopViewDelegate
        if let searchResultVC = listTopViewDelegate as? SearchResultListViewController {
            var caster = CasterSearchResult()
            caster.tags = ["One", "Two"]
            searchResultVC.setDataItem(dataItem: caster)
        }
        XCTAssertNotNil(listTopView.delegate)
        XCTAssertNoThrow(listTopViewDelegate.infoButton(tapped: true))
    }
    
}
