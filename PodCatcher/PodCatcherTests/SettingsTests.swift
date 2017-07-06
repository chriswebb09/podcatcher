import XCTest
@testable import PodCatcher

class SettingsTests: XCTestCase {
    
    var settingsView: SettingsView!
    var settingsViewController: SettingsViewController!
    
    override func setUp() {
        super.setUp()
        let settingsViewModel = SettingsViewModel(firstSettingOptionText: "one", secondSettingOptionText: "two")
        settingsView = SettingsView(frame: UIScreen.main.bounds, model: settingsViewModel)
    }
    
    override func tearDown() {
        settingsView = nil
        settingsViewController = nil
        super.tearDown()
    }
    
    func testOptionOneTapped() {
        let testDelegate = SettingsTestDelegate()
        XCTAssertEqual(testDelegate.settingTapped, "One")
    }
    
    func testOptionTwoTapped() {
        let testDelegate = SettingsTestDelegate()
        settingsViewController.delegate = testDelegate
        settingsViewController.settingTwo(tapped: true)
        XCTAssertEqual(testDelegate.settingTapped, "Two")
    }
}

class SettingsTestDelegate: SettingsViewControllerDelegate {
    
    var settingTapped: String = ""
    
    func settingOne(tapped: Bool) {
        XCTAssertTrue(tapped)
        settingTapped = "One"
    }
    
    func settingTwo(tapped: Bool) {
        XCTAssertTrue(tapped)
        settingTapped = "Two"
    }
    
    func guestUserSignIn(tapped: Bool) {
        XCTAssertTrue(tapped)
    }
}
