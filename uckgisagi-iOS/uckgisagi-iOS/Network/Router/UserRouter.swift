//
//  UserRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Foundation

import Moya

enum UserRouter {
    case search(nickname: String)
}

extension UserRouter: BaseTargetType {
    var path: String {
        switch self {
        case .search:
            return "/user/search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .search(nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.default
            )
        }
    }
}
