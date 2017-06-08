import XCTest
@testable import PodCatcher

class PodCatcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignIn() {
        let expect = expectation(description: "API Client returns proper number of items from search")
        UserLoginAPIClient.login(with: "testuser", and: "123456") { data in
            guard let userData = data.1 else { return }
            guard let testUsename = userData["username"] as? String else { return }
            guard let testEmail = userData["email"] as? String else { return }
            guard let testCasts = userData["casters"] as? [Caster] else { return }
            guard let customGenre = userData["customGenre"] as? [String] else { return }
            let user = PodCatcherUser(username: testUsename, emailAddress: testEmail)
            user.customGenres = customGenre
            user.casts = testCasts
            expect.fulfill()
            XCTAssertTrue(testCasts.count > 0, "Test casts count is greater than zero")
        }
        waitForExpectations(timeout: 6) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
