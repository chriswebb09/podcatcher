import XCTest
import Firebase

@testable import PodCatcher

class PodCatcherUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStart() {
        XCTAssert(app.buttons["Continue"].exists)
        XCTAssert(app.buttons["Login"].exists)
        XCTAssert(app.buttons["Don't have an account?"].exists)
    }
    
    func testLogin() {
        XCTAssert(app.buttons["Continue"].exists)
        XCTAssert(app.buttons["Login"].exists)
        XCTAssert(app.buttons["Don't have an account?"].exists)
        app.buttons["Login"].tap()
        XCTAssert(app.navigationBars.staticTexts["Login"].exists)
        XCTAssert(app.textFields["Email Address"].exists)
        XCTAssert(app.buttons["Login"].exists)
    }
    
    func testBack() {
        XCTAssert(app.buttons["Continue"].exists)
        XCTAssert(app.buttons["Login"].exists)
        XCTAssert(app.buttons["Don't have an account?"].exists)
        app.buttons["Login"].tap()
        XCTAssert(app.navigationBars.buttons["Back"].exists)
    }
    
    func testCreateAccount() {
        XCTAssert(app.buttons["Continue"].exists)
        XCTAssert(app.buttons["Login"].exists)
        XCTAssert(app.buttons["Don't have an account?"].exists)
        app.buttons["Don't have an account?"].tap()
        XCTAssert(app.navigationBars.buttons["Back"].exists)
    }
}
