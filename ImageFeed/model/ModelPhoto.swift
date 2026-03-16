//
//  ModelPhoto.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 14/03/2026.
//

import Foundation

struct Photo {
      let id: String
      let size: CGSize
      let createdAt: Date?
      let welcomeDescription: String?
      let thumbImageURL: String
      let largeImageURL: String
      let isLiked: Bool
  }

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let welcomeDescription: String?
    let urls: Urls
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
    }
}

struct Urls: Decodable {
    let thumbImageURL: String
    let largeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}
