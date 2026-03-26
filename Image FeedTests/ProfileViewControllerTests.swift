//
//  ProfileViewControllerTests.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

@testable import ImageFeed
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    func testViewDidLoadCallsPresenterViewDidLoad() {
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()

        viewController.configure(presenterSpy)
        _ = viewController.view

        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }

    func testConfigureSetsPresenterView() {
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()

        viewController.configure(presenterSpy)

        XCTAssertNotNil(presenterSpy.view)
    }

    func testDidTapLogoutButtonCallsPresenter() {
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()

        viewController.configure(presenterSpy)
        _ = viewController.view

        viewController.didTapButton()

        XCTAssertTrue(presenterSpy.didTapLogoutButtonCalled)
    }

    func testDisplayProfileUpdatesLabels() {
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()

        viewController.configure(presenterSpy)
        _ = viewController.view

        viewController.displayProfile(
            name: "Mikita Ivanou",
            login: "@mikita",
            bio: "iOS Developer"
        )

        XCTAssertEqual(viewController.labelName.text, "Mikita Ivanou")
        XCTAssertEqual(viewController.labelPersonTag.text, "@mikita")
        XCTAssertEqual(viewController.labelGreeting.text, "iOS Developer")
    }
}
