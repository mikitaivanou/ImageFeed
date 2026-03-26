//
//  ImagesListViewControllerTests.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    private func makeSUT() -> (ImagesListViewController, ImagesListPresenterSpy) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ImagesListViewController.self))
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        
        let presenterSpy = ImagesListPresenterSpy()
        presenterSpy.setPhotos([
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: nil,
                welcomeDescription: nil,
                thumbImageURL: "https://example.com/thumb.jpg",
                largeImageURL: "https://example.com/large.jpg",
                isLiked: false
            )
        ])
        
        viewController.configure(presenterSpy)
        viewController.loadViewIfNeeded()
        
        return (viewController, presenterSpy)
    }
    
    func testViewDidLoadCallsPresenter() {
        let (_, presenterSpy) = makeSUT()
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testNumberOfRowsMatchesPresenterPhotosCount() {
        let (viewController, _) = makeSUT()
        let tableView = findTableView(in: viewController)
        
        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 0), 1)
    }
    
    func testWillDisplayLastCellCallsPresenterDidScrollToLastCell() {
        let (viewController, presenterSpy) = makeSUT()
        let tableView = findTableView(in: viewController)
        let cell = UITableViewCell()
        
        viewController.tableView(
            tableView,
            willDisplay: cell,
            forRowAt: IndexPath(row: 0, section: 0)
        )
        
        XCTAssertTrue(presenterSpy.didScrollToLastCellCalled)
    }
    
    private func findTableView(in viewController: UIViewController) -> UITableView {
        let allSubviews = viewController.view.subviews
        guard let tableView = allSubviews.first(where: { $0 is UITableView }) as? UITableView else {
            XCTFail("TableView not found")
            return UITableView()
        }
        return tableView
    }
}
