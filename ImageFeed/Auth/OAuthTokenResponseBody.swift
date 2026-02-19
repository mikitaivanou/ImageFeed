//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 19/02/2026.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
