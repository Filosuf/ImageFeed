//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Filosuf on 02.12.2022.
//

import Foundation

struct LikeResult: Decodable {
    let photo: PhotoResult
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let isLiked: Bool
    let description: String?
    let urls: UrlsResult


    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
        case description
        case urls
    }
}

struct UrlsResult : Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
