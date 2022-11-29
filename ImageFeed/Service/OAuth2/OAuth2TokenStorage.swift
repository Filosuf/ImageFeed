//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Filosuf on 11.11.2022.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    private let userDefaults = UserDefaults.standard
    private let tokenKey = "tokenKey"
    var token: String? {
        get {
            print("read token \(tokenKey)")
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            let isSuccess = KeychainWrapper.standard.set(newValue ?? "", forKey: tokenKey)
            guard isSuccess else {
                print("Don't save token \(newValue ?? "Token empty"). Keychain Error")
                return
            }
            print("Save token \(newValue ?? "Token empty")")
        }
    }
}
