import XCTest
@testable import PodCatcher

class SettingsTests: XCTestCase {
    
    var settingsView: SettingsView!
    var settingsViewController: SettingsViewController!
    
    override func setUp() {
        super.setUp()
        settingsView = SettingsView()
        settingsViewController = SettingsViewController(settingsView: settingsView)
    }
    
    override func tearDown() {
        settingsView = nil
        settingsViewController = nil
        super.tearDown()
    }
    
    func testOptionOneTapped() {
        let testDelegate = SettingsTestDelegate()
        settingsViewController.delegate = testDelegate
        settingsViewController.settingOneTapped()
        XCTAssertEqual(testDelegate.settingTapped, "One")
    }
    
    func testOptionTwoTapped() {
        let testDelegate = SettingsTestDelegate()
        settingsViewController.delegate = testDelegate
        settingsViewController.settingTwoTapped()
        XCTAssertEqual(testDelegate.settingTapped, "Two")
    }
}

class SettingsTestDelegate: SettingsViewControllerDelegate {
    
    var settingTapped: String = ""
    
    func settingOneTapped(tapped: Bool) {
        XCTAssertTrue(tapped)
        settingTapped = "One"
    }
    
    func settingTwoTapped(tapped: Bool) {
        XCTAssertTrue(tapped)
        settingTapped = "Two"
    }
}
