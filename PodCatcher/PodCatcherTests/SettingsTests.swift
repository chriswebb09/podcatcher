//
//  SettingsTests.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 6/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

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
