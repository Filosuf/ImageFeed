//
//  Profile.swift
//  ImageFeed
//
//  Created by Filosuf on 27.11.2022.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String

    init(profileResult: ProfileResult) {
        username = profileResult.username
        name = profileResult.firstName + " " + profileResult.lastName
        loginName = "@" + profileResult.username
        bio = profileResult.bio ?? ""
    }
}
