//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Filosuf on 11.11.2022.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    private let storage = KeychainWrapper.standard
    private let tokenKey = "tokenKey"
    var token: String? {
        get {
            storage.string(forKey: tokenKey)
        }
        set {
            storage.set(newValue ?? "", forKey: tokenKey)
        }
    }
}
