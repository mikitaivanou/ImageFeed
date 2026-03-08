//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 23/02/2026.
//

import UIKit

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
  
    private var imageView: UIImageView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let storage = OAuth2TokenStorage.shared
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           view.backgroundColor = .ypBlack
           setupImageView()
           
           if storage.token != nil, let token = storage.token {
   //            switchToTabBarController()
               fetchProfile(token: token)
           } else {
               // Show Auth Screen
               presentAuthViewController()
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupImageView() {
            let imageSplashScreenLogo = UIImage(named: "splashScreenLogo")

            imageView = UIImageView(image: imageSplashScreenLogo)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        private func presentAuthViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                assertionFailure("Не удалось найти AuthViewController по идентификатору")
                return
            }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }

    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case let .success(profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()

            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
}


extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else {
                    return
                }
                
                fetchProfile(token: token)
            
//        switchToTabBarController()
    }
}
