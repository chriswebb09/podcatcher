import XCTest
@testable import PodCatcher

class SettingsTests: XCTestCase {
    var settingsViewController: SettingsViewController!
    
    override func setUp() {
        super.setUp()
      
    }
    
    override func tearDown() {
        settingsViewController = nil
        super.tearDown()
    }
    
    func testOptionOneTapped() {
     
      //  XCTAssertEqual(testDelegate.settingTapped, "One")
    }
    
    func testOptionTwoTapped() {
   
//        settingsViewController.delegate = testDelegate
//        settingsViewController.settingTwo(tapped: true)
//        XCTAssertEqual(testDelegate.settingTapped, "Two")
    }
}


