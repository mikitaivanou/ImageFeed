//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }

    func viewDidLoad()
    func didTapLogoutButton()
    func didConfirmLogout()
}
