//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 19/02/2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "token"
    private init() {}
}
