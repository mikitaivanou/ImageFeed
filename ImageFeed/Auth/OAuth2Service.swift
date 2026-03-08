//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 19/02/2026.
//

import Foundation
final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private init() {}
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            DispatchQueue.main.async{
                completion(.failure(NetworkError.invalidRequest))
            }
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    OAuth2TokenStorage.shared.token = authToken
                    completion(.success(authToken))
                    self.task = nil
                    self.lastCode = nil
                case .failure(let error):
                    print("[fetchOAuthToken]: Ошибка запроса: \(error.localizedDescription)")
                    completion(.failure(error)) // ошибка
                    
                    self.task = nil
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String?) -> URLRequest? {
        guard var components = URLComponents(string: "https://unsplash.com/oauth/token")
        else {
            return nil
        }
        components.queryItems = [
            URLQueryItem(name:"client_id", value: Constants.accessKey),
            URLQueryItem(name:"client_secret", value: Constants.secretKey),
            URLQueryItem(name:"redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name:"code", value: code),
            URLQueryItem(name:"grant_type", value: "authorization_code"),
        ]
        
        guard let url = components.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
