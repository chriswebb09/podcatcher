import XCTest
@testable import PodCatcher

class SettingsTests: XCTestCase {
    
    var settingsView: SettingsView!
    var settingsViewController: SettingsViewController!
    
    override func setUp() {
        super.setUp()
        let settingsViewModel = SettingsViewModel(firstSettingOptionText: "one", secondSettingOptionText: "two")
        settingsView = SettingsView(frame: UIScreen.main.bounds, model: settingsViewModel)
        let dataSource = BaseMediaControllerDataSource(casters: [])
        settingsViewController = SettingsViewController(settingsView: settingsView, dataSource: dataSource)
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
    
    func guestUserSignInTapped(tapped: Bool) {
        XCTAssertTrue(tapped)
    }
}