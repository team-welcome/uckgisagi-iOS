//
//  Environment.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/15.
//

import Foundation

enum Environment {
    static var baseURL: String {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String
        else {
            return ""
        }
        return urlString
    }
}
