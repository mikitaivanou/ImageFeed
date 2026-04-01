//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 15/02/2026.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let segueName = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueName {
            guard
                let webViewViewController  = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(segueName)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.delegate?.didAuthenticate(self)
                print("Token received:", token)
                vc.dismiss(animated: true)
            case .failure(let error):
                print("[AuthViewController.webViewViewController] Ошибка: \(error.localizedDescription)")
                self.showAuthErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}



extension AuthViewController {
    func showAuthErrorAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
