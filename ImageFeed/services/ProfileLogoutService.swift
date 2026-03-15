
//
//  ProfileLogoutService.swift
//  ReviewGoImageFeed
//
//  Created by Mikita Ivanou on 12/03/2026.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    let profileService = ProfileService.shared
    private let imagesListService = ImagesListService.shared
    let userAvatar = ProfileImageService.shared
    
    private init() { }
    
    func logout() {
        cleanCookies()
    }
    
    private func cleanCookies() {// Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        profileService.logoutProfile()
        imagesListService.logoutImageListService()
        userAvatar.logout()
        OAuth2TokenStorage.shared.token = nil
    }
    
    
}

