//
//  UserDefaultHandler.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

struct UserDefaultHandler {
    static var shared = UserDefaultHandler()

    private init() {}

    enum Key: String {
        case nickname = "nickname"
    }

    @UserDefault(key: Key.nickname.rawValue, defaultValue: "")
    var nickname: String

    func removeAll() {
        _nickname.reset()
    }
}
