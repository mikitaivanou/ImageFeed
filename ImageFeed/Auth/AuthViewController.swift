//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 15/02/2026.
//

import UIKit

class AuthViewController: UIViewController {
    
    
 
    let segueName = "ShowWebView"
    
    @IBAction func enterButton(_ sender: Any) {
    }
    
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
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configureBackButton() {
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
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            switch result {
                
            case .success(let token):
                print("Token received:", token)
                vc.dismiss(animated: true)
                
            case .failure(let error):
                print("Authorization error:", error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}



