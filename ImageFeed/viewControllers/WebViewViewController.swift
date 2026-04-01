//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 15/02/2026.
//
import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

class WebViewViewController: UIViewController&WebViewViewControllerProtocol {
    
    //    enum WebViewConstants {
    //        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    //    }
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        loadAuthView()
        presenter?.viewDidLoad()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        estimatedProgressObservation = webView.observe(
    //            \.estimatedProgress,
    //             options: [],
    //             changeHandler: { [weak self] _, _ in
    //                 guard let self = self else { return }
    //                 self.updateProgress()
    //             })
    //        updateProgress()
    //    }
    
    
    //MARK: обработка процесса загрузки 2-0
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    //MARK: обработка процесса загрузки 2-1
    
    //MARK: новый метод
    func load(request: URLRequest) {
        print("пришло на вью !!!")
        webView.load(request)
    }
    //MARK: конец нвоого метода
    //    private func updateProgress() {
    //        progressView.progress = Float(webView.estimatedProgress)
    //        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    //    }
    
    //MARK: обработка процесса загрузки 1-0
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    //MARK: обработка процесса загрузки 1-1
    
    
    //    private func loadAuthView() {
    //        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString)
    //        else {return}
    //        urlComponents.queryItems = [
    //            URLQueryItem(name: "client_id", value: Constants.accessKey),
    //            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
    //            URLQueryItem(name: "response_type", value: "code"),
    //            URLQueryItem(name: "scope", value: Constants.accessScope)
    //        ]
    //        guard let url = urlComponents.url
    //        else {return}
    //        let request = URLRequest(url: url)
    //        webView.load(request)
    //    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView( _ webView: WKWebView,
                  decidePolicyFor navigationAction: WKNavigationAction,
                  decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url{
            return presenter?.code(from: url)
        }
        return nil
    }
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

