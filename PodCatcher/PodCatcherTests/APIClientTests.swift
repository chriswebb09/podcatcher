//
//  APIClientTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
@testable import Firebase
@testable import PodCatcher

class APIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignIn() {
        let expect = expectation(description: "User exists")
        UserDataAPIClient.loginToAccount(email: "Link@link.com", password: "123456") { user, error in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            expect.fulfill()
        }
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testSignInWrongInfo() {
        let expect = expectation(description: "User exists")
        UserDataAPIClient.loginToAccount(email: "Link@link.com", password: "123455") { user, error in
            XCTAssertNotNil(error)
            XCTAssertNil(user)
            expect.fulfill()
        }
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout error: \(error)")
            }
        }
    }
}
