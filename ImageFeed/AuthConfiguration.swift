//
//  Constants.swift
//  ImageFeed
//
//  Created by Filosuf on 08.11.2022.
//

import Foundation

enum Constants {
    static let accessKey = "9IVJF5YFkFYdbQGuof46n4IDEGc8xrM4pjyingtQq50"
    static let secretKey = "gqEVLz-CHNrw0gc_9Y0u_rDB6_vVz1bsGivMTpOD0vY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.unsplashAuthorizeURLString)
    }

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

