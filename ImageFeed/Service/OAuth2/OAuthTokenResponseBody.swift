//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Filosuf on 10.11.2022.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
