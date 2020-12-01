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
    func testMakeNewUser() {
        app.launch()
        app.buttons["signupButton"].tap()
        let emailAddressTextField = application.ViewControllers.SignupViewController.textFields["emailField"]
        emailAddressTextField.tap()
        emailAddressTextField.typeText("testuser@bu.edu")
        
        let usernameTextField = application.ViewControllers.SignupViewController.textFields["usernameField"]
        usernameTextField.tap()
        usernameTextField.typeText("Test User")
        
        let passwordTextField = application.ViewControllers.SignupViewController.textFields["passwordField"]
        passwordTextField.tap()
        passwordTextField.typeText("Password2020!")
        
        let confirmPasswordTextField = application.ViewControllers.SignupViewController.textFields["confirmPasswordField"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("Password2020!")
        
        app.buttons["signinButton"].tap()
        //what button should we use in the assert?
        XCTAssertTrue(app.buttons["Unknown"].exists)
    }
    func testMakeNewUser() {
        app.launch()
        app.buttons["signupButton"].tap()
        let emailAddressTextField = application.ViewControllers.SignupViewController.textFields["emailField"]
        emailAddressTextField.tap()
        emailAddressTextField.typeText("testuseratbudotedu")
        
        let usernameTextField = application.ViewControllers.SignupViewController.textFields["usernameField"]
        usernameTextField.tap()
        usernameTextField.typeText("Test User")
        
        let passwordTextField = application.ViewControllers.SignupViewController.textFields["passwordField"]
        passwordTextField.tap()
        passwordTextField.typeText("Password2020!")
        
        let confirmPasswordTextField = application.ViewControllers.SignupViewController.textFields["confirmPasswordField"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("Password2020!")
        
        app.buttons["signinButton"].tap()
        //Assert should check if a warning popped up about email being invalid
        XCTAssertTrue(app.buttons["Unknown"].exists)
    }
    func testMakeNewUser() {
        app.launch()
        app.buttons["signupButton"].tap()
        let emailAddressTextField = application.ViewControllers.SignupViewController.textFields["emailField"]
        emailAddressTextField.tap()
        emailAddressTextField.typeText("testuser@bu.edu")
        
        let usernameTextField = application.ViewControllers.SignupViewController.textFields["usernameField"]
        usernameTextField.tap()
        usernameTextField.typeText("Test User")
        
        let passwordTextField = application.ViewControllers.SignupViewController.textFields["passwordField"]
        passwordTextField.tap()
        passwordTextField.typeText("123")
        
        let confirmPasswordTextField = application.ViewControllers.SignupViewController.textFields["confirmPasswordField"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("123")
        
        app.buttons["signinButton"].tap()
        //Assert should check if a warning popped up about pasdsowrd being too short
        XCTAssertTrue(app.buttons["Unknown"].exists)
    }
    func testMakeNewUser() {
        app.launch()
        app.buttons["signupButton"].tap()
        let emailAddressTextField = application.ViewControllers.SignupViewController.textFields["emailField"]
        emailAddressTextField.tap()
        emailAddressTextField.typeText("testuser@bu.edu")
        
        let usernameTextField = application.ViewControllers.SignupViewController.textFields["usernameField"]
        usernameTextField.tap()
        usernameTextField.typeText("Test User")
        
        let passwordTextField = application.ViewControllers.SignupViewController.textFields["passwordField"]
        passwordTextField.tap()
        passwordTextField.typeText("Password2020!")
        
        let confirmPasswordTextField = application.ViewControllers.SignupViewController.textFields["confirmPasswordField"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("nope")
        
        app.buttons["signinButton"].tap()
        //Assert should check if a warning popped up about passwords not matching
        XCTAssertTrue(app.buttons["Unknown"].exists)
    }
}
