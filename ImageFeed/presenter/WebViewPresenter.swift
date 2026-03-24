//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 24/03/2026.
//

import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    
    func viewDidLoad() {
//          guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
//              return
//          }
//
//          urlComponents.queryItems = [
//              URLQueryItem(name: "client_id", value: Constants.accessKey),
//              URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//              URLQueryItem(name: "response_type", value: "code"),
//              URLQueryItem(name: "scope", value: Constants.accessScope)
//          ]
//
//          guard let url = urlComponents.url else {
//              return
//          }
//
//          let request = URLRequest(url: url)
        guard let request = authHelper.authRequest() else {
            print("authRequest is nil")
            return }
  
        didUpdateProgressValue(0)
        
          view?.load(request: request)
        print(request)
        print("на вью уходит ")
      }
    
    func didUpdateProgressValue(_ newValue: Double) {
            let newProgressValue = Float(newValue)
            view?.setProgressValue(newProgressValue)
            
            let shouldHideProgress = shouldHideProgress(for: newProgressValue)
            view?.setProgressHidden(shouldHideProgress)
        }
        
        func shouldHideProgress(for value: Float) -> Bool {
            abs(value - 1.0) <= 0.0001
        }
    
    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
        
        authHelper.code(from: url)
    }
}
