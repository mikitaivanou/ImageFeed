//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 19/02/2026.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data)) 
                } else {
                    let error = NetworkError.httpStatusCode(statusCode)
                    print("[URLSession extension.data] Ошибка: \(error.localizedDescription)")
                    fulfillCompletionOnTheMainThread(.failure(error))
                }
            } else if let error = error {
                let networkError = NetworkError.urlRequestError(error)
                               print("[URLSession extension.data] Ошибка: \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(networkError))
            } else {
                let error = NetworkError.urlSessionError
                               print("[URLSession extension.data] Ошибка: \(error)")
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        })
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Полученные данные: \(jsonString)")
                }
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    let decodingError = NetworkError.decodingError(error)
                    print("[URLSession extension.objectTask] Ошибка: \(error.localizedDescription)")
                    print("Данные ответа: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(decodingError))
                }
            case .failure(let error):
                print("[URLSession extension.objectTask] Ошибка: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}
