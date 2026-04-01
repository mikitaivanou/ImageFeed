//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var didConfirmLogoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func didConfirmLogout() {
        didConfirmLogoutCalled = true
    }
}
