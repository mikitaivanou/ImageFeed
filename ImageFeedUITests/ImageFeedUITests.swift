//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Mikita Ivanou on 26/03/2026.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launchArguments = ["FIRST_PAGE_ONLY"]
        app.launch()
    }
    

    
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 10))
        authButton.tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))

        let loginCoordinate = loginTextField.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        loginCoordinate.tap()
        loginCoordinate.tap()

        XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 5))
        app.typeText("ivanovnk30@gmail.com")

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))

        UIPasteboard.general.string = "erica1215"

        let passwordCoordinate = passwordTextField.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        passwordCoordinate.tap()
        passwordTextField.press(forDuration: 1.2)

        let pasteMenuItem = app.menuItems["Paste"]
        XCTAssertTrue(pasteMenuItem.waitForExistence(timeout: 5))
        pasteMenuItem.tap()

        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        loginButton.tap()

        let firstCell = app.tables.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
    }
    

    
    func testFeed() throws {
        let table = app.tables.element
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        let firstCell = table.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))

        table.swipeUp()
        sleep(1)

        guard let visibleCell = topVisibleCell(in: table) else {
            XCTFail("Не удалось найти первую видимую ячейку")
            return
        }

        scrollDownBy40Percent(in: table)
        sleep(1)

        let likeButton = visibleCell.buttons["likeButton"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        likeButton.tap()
        likeButton.tap()

        visibleCell.tap()
        
        sleep(5)

        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))

        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButton = app.buttons["navBackButton"]
        XCTAssertTrue(navBackButton.waitForExistence(timeout: 5))
        navBackButton.tap()
    }

    func topVisibleCell(in table: XCUIElement) -> XCUIElement? {
        let tableFrame = table.frame

        return table.cells.allElementsBoundByIndex
            .filter { cell in
                let frame = cell.frame
                return cell.exists &&
                       !frame.isEmpty &&
                       frame.maxY > tableFrame.minY &&
                       frame.minY < tableFrame.maxY
            }
            .min(by: { $0.frame.minY < $1.frame.minY })
    }

    func scrollDownBy40Percent(in element: XCUIElement) {
        let start = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        let finish = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.7))
        start.press(forDuration: 0.01, thenDragTo: finish)
    }
    func testProfile() throws {
        sleep(10)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name"].exists)
        XCTAssertTrue(app.staticTexts["tag"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}

