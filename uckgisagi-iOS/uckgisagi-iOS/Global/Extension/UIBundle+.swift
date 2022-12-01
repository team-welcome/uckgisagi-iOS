//
//  UIBundle+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/01.
//

import Foundation

extension Bundle {
    static var appVersion: String {
        guard
            let version = self.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else {
           return ""
        }
        return version
    }
}
