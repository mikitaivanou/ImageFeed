//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?
    
    var viewDidLoadCalled = false
    var didScrollToLastCellCalled = false
    var didTapLikeCalled = false
    var photosCount: Int = 0
    
    private var stubPhotos: [Photo] = []
    
    func setPhotos(_ photos: [Photo]) {
        stubPhotos = photos
        photosCount = photos.count
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photo(at indexPath: IndexPath) -> Photo {
        stubPhotos[indexPath.row]
    }
    
    func imageURL(for indexPath: IndexPath) -> URL? {
        URL(string: stubPhotos[indexPath.row].thumbImageURL)
    }
    
    func formattedDate(for indexPath: IndexPath) -> String? {
        "1 января 2025"
    }
    
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        didTapLikeCalled = true
        completion(true)
    }
    
    func didScrollToLastCell() {
        didScrollToLastCellCalled = true
    }
    
    func heightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        200
    }
}
