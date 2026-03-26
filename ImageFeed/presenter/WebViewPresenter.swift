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
        
        
        authHelper.code(from: url)
    }
}
