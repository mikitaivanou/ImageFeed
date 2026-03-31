//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 14/03/2026.
//

import UIKit


final class ImagesListService {
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private init() {}
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        //for UItest
        if ProcessInfo.processInfo.arguments.contains("FIRST_PAGE_ONLY"),
                   nextPage > 1 {
                    return
                }
        //for UItest
        
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService. fetchPhotosNextPage - Нет токена]")
            return }
        guard let request = makePhotoListRequest(nextPage: nextPage, token: token) else { print("[ImagesListService. fetchPhotosNextPage] Ошибка при получении URLRequest")
            return }
        let newTask = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let imageList):
                let newImages = imageList.map { image in
                    Photo(
                        id: image.id,
                        size: CGSize(width: image.width, height: image.height),
                        createdAt: image.createdAt,
                        welcomeDescription: image.welcomeDescription,
                        thumbImageURL: image.urls.thumbImageURL,
                        largeImageURL: image.urls.largeImageURL,
                        isLiked: image.isLiked
                    )
                    
                }
                self.photos.append(contentsOf: newImages)
                if !newImages.isEmpty {
                    self.lastLoadedPage = nextPage
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                
            case .failure(let error):
                print("[ImagesListService. fetchPhotosNextPage] Ошибка при получении данных: \(error.localizedDescription)")
            }
            
            self.task = nil
        }
        self.task = newTask
        newTask.resume()
        
    }
    
    private func makePhotoListRequest(nextPage: Int, token: String) -> URLRequest? {
        guard var components = URLComponents(string: "https://api.unsplash.com/photos")
        else {
            print("[ImagesListService.makePhotoListRequest] Ошибка при формировании URL-запроса")
            return nil
        }
        components.queryItems = [
            URLQueryItem(name:"page", value: "\(nextPage)"),
            URLQueryItem(name:"per_page", value: "10")
        ]
        guard let url = components.url else {
            print("[ImagesListService.makePhotoListRequest] Ошибка при формировании URL-запроса")
            return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "NoToken", code: 0)))
            return
        }
        
        let httpMethod = isLike ? "POST" : "DELETE"
        
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [weak self] _, _, error in
            
            guard let self  else { return }
            if let error = error {
                DispatchQueue.main.async {
                    print("[ImagesListService.changeLike] Ошибка: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                return
            }
            
            DispatchQueue.main.async {
                
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    
                    let photo = self.photos[index]
                    
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    
                    self.photos[index] = newPhoto
                }
                
                completion(.success(()))
            }
        }
        
        task.resume()
    }
    
    func logoutImageListService() {
        self.photos = []
    }
    
}
