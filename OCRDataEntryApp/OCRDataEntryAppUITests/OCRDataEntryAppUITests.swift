//
//  OCRDataEntryAppUITests.swift
//  OCRDataEntryAppUITests
//
//  Created by Eesha Gholap on 11/30/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import XCTest

class OCRDataEntryAppUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testSignUpButtonDisplays() {
        app.launch()
        XCTAssertTrue(app.buttons["Login"].exists)
    }
    
    func testContinueButtonShowsNextUi() {
        app.launch()
        app.buttons["Login"].tap()
        XCTAssertFalse(app.buttons["Miranda Form"].exists)
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
