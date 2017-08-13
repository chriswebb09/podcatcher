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
    
}
