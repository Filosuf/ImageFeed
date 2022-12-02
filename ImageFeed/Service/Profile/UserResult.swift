//
//  UserResult.swift
//  ImageFeed
//
//  Created by Filosuf on 28.11.2022.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
