//
//  FilamentSwatchesScreenshots.swift
//  FilamentSwatchesScreenshots
//
//  Created by Jonas Frey on 04.05.23.
//

import XCTest

final class FilamentSwatchesScreenshots: XCTestCase {
    private var app: XCUIApplication!
    private var screenshotCounter: Int!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--screenshots")
        setupSnapshot(app)
        screenshotCounter = 1
    }
    
    override func tearDownWithError() throws {
        // Tear down...
    }
    
    func testTakeAppStoreScreenshots() throws {
        app.launch()
        
        snapshot("Home")
        
        app.tabBars.buttons["library-tab"].tap()
        snapshot("Library")
        
        app.navigationBars.buttons["add-swatch"].tap()
        snapshot("CreateSwatch")
        app.swipeDown(velocity: .fast)
        
        // First list row
        app.buttons.element(boundBy: 5).tap()
        snapshot("SwatchView")
        app.swipeDown(velocity: .fast)
        
        app.tabBars.buttons["materials-tab"].tap()
        snapshot("Materials")
        
        app.tabBars.buttons["settings-tab"].tap()
        snapshot("Settings")
    }
    
    // Take a snapshot with a global increasing counter as a prefix
    private func snapshot(_ name: String) {
        Snapshot.snapshot("\(String(format: "%02d", screenshotCounter))_\(name)")
        screenshotCounter += 1
    }
}
