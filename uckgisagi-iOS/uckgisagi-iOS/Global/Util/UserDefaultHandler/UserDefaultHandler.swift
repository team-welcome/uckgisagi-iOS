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
        case example = "example"
    }

    @UserDefault(key: Key.example.rawValue, defaultValue: "")
    var example: String

    func removeAll() {
        _example.reset()
    }
}
