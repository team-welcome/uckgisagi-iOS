//
//  KeyChainHandler.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import SwiftKeychainWrapper

struct KeychainHandler {
    static var shared = KeychainHandler()

    private init() {}

    private let keychain = KeychainWrapper.standard
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let fcmTokenKey = "fcmToken"

    var accessToken: String {
        get {
            return keychain.string(forKey: accessTokenKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: accessTokenKey)
        }
    }

    var refreshToken: String {
        get {
            return keychain.string(forKey: refreshTokenKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: refreshTokenKey)
        }
    }

    var fcmToken: String {
        get {
            return keychain.string(forKey: fcmTokenKey) ?? ""
        }
        set {
            keychain.set(newValue, forKey: fcmTokenKey)
        }
    }

    mutating func removeAll() {
        accessToken = ""
        refreshToken = ""
        fcmToken = ""
    }

}
