//
//  BaseTargetType.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/15.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    var version: String {
        return "/v1"
    }

    var baseURL: URL {
        return URL(string: Environment.baseURL + version)!
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainHandler.shared.accessToken)"
        ]
    }

    var sampleData: Data {
        return Data()
    }
}
