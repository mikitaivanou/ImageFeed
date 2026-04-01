//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let profileLogoutService: ProfileLogoutService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        profileLogoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        if let profile = profileService.profile {
            let name = profile.name.isEmpty ? "Имя не указано" : profile.name
            let login = profile.loginName.isEmpty ? "@неизвестный_пользователь" : profile.loginName
            let bio = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : (profile.bio ?? "")
            
            view?.displayProfile(name: name, login: login, bio: bio)
        }
        
        if let avatarURLString = profileImageService.avatarURL,
           let url = URL(string: avatarURLString) {
            view?.displayAvatar(url: url)
        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard
                let self,
                let avatarURLString = self.profileImageService.avatarURL,
                let url = URL(string: avatarURLString)
            else { return }
            
            self.view?.displayAvatar(url: url)
        }
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert()
    }
    
    func didConfirmLogout() {
        profileLogoutService.logout()
        view?.switchToSplashScreen()
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
