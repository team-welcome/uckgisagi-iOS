//
//  UserDefault.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

    func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

