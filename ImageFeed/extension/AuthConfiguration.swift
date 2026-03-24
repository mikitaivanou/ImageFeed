//
//  Constants.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 15/02/2026.
//

import Foundation


    enum Constants {
        static let accessKey = "4rg2uEGFWB6N1yqicLiejqQsG1U3DtnJOvT7Zsy8o38"
        static let secretKey = "CjTkPX8OfUl_WAz4IWU6aymfAXa1jz4HKLgAP9YYr3o"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static var defaultBaseURLString: URL {
            guard let url = URL(string: "https://api.unsplash.com") else {
                fatalError("Invalid base URL")
            }
            return url
        }
    }

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURLString: URL
    

//    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURLString: String) {
//        self.accessKey = accessKey
//        self.secretKey = secretKey
//        self.redirectURI = redirectURI
//        self.accessScope = accessScope
//        self.defaultBaseURLString = defaultBaseURLString
//        self.authURLString = authURLString
    
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     authURLString: Constants.unsplashAuthorizeURLString,
                                     defaultBaseURLString: Constants.defaultBaseURLString)
        }
}
