//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Filosuf on 11.11.2022.
//

import Foundation

final class OAuth2TokenStorage {

    private let userDefaults = UserDefaults.standard
    private let tokenKey = "tokenKey"
    var token: String? {
        get {
            print("read token \(tokenKey)")
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            print("Save token \(newValue)")
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }

}
