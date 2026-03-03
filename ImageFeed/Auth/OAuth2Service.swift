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
    
    //        устранение гонки 0.0
    private var task: URLSessionTask?
    private var lastCode: String?
    //        устранение гонки 0.1
    
    
    private init() {}
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
//        устранение гонки 1.0
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code
        
//        устранение гонки 1.1
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            
            DispatchQueue.main.async{
                completion(.failure(NetworkError.invalidRequest))
            }
            return
        }
        let task = urlSession.data(for: request) { [weak self] result in

               DispatchQueue.main.async {
                   defer {
                       // всегда очищаем состояние
                       self?.task = nil
                       self?.lastCode = nil
                   }

                   switch result {
                   case .success(let data):
                       do {
                           let decoder = JSONDecoder()
                           let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                           let token = response.accessToken
                           OAuth2TokenStorage.shared.token = token
                           completion(.success(token))
                       } catch {
                           completion(.failure(NetworkError.decodingError(error)))
                       }

                   case .failure(let error):
                       completion(.failure(error))
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
