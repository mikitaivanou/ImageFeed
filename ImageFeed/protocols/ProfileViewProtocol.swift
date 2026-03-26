//
//  ProfileViewProtocol.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func displayProfile(name: String, login: String, bio: String)
    func displayAvatar(url: URL)
    func showLogoutAlert()
    func switchToSplashScreen()
}
