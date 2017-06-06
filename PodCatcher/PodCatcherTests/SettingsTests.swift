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
}
