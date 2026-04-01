//
//  Untitled.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 24/03/2026.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}


final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }

    func authURL() -> URL? {
        print("проверка получения URL из константы")
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            print("проверка получения URL из константы не прошла")

            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        print("проверка получения URL из константы")
        return urlComponents.url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            print("не получили код")
            return codeItem.value
        } else {
            return nil
        }
    }
}
