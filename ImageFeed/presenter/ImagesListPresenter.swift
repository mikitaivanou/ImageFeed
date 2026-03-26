//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

import Foundation
import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?

    private let imagesListService: ImagesListService
    private var photos: [Photo] = []

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }

    var photosCount: Int {
        photos.count
    }

    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePhotos),
            name: ImagesListService.didChangeNotification,
            object: nil
        )

        imagesListService.fetchPhotosNextPage()
    }

    @objc
    private func updatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count

        photos = imagesListService.photos
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }

    func photo(at indexPath: IndexPath) -> Photo {
        photos[indexPath.row]
    }

    func imageURL(for indexPath: IndexPath) -> URL? {
        URL(string: photos[indexPath.row].thumbImageURL)
    }

    func formattedDate(for indexPath: IndexPath) -> String? {
        guard let date = photos[indexPath.row].createdAt else { return nil }
        return dateFormatter.string(from: date)
    }

    func didTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let photo = photos[indexPath.row]

        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                completion(true)
            case .failure:
                self.view?.showErrorAlert()
                completion(false)
            }
        }
    }

    func didScrollToLastCell() {
        imagesListService.fetchPhotosNextPage()
    }

    func heightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        return image.size.height * scale + imageInsets.top + imageInsets.bottom
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
