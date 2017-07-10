//
//  StringMethodTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 7/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import PodCatcher

class StringMethodTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
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
