//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 19/02/2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private init() {}
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "token"
    var token: String? {
        get {
            // Получаем токен из Keychain
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                // Сохраняем токен в Keychain
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                // Удаляем токен из Keychain
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }

    
    
    
}
