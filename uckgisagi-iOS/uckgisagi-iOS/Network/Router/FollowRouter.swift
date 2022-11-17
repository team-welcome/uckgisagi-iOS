//
//  FollowRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Foundation

import Moya

enum FollowRouter {
    case follow(userID: Int)
    case unfollow(userID: Int)
}

extension FollowRouter: BaseTargetType {
    var path: String {
        switch self {
        case .follow:
            return "/follow"
        case let .unfollow(userID):
            return "/unfollow/\(userID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .follow:
            return .post
        case .unfollow:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case let .follow(userID):
            return .requestParameters(
                parameters: ["targetUserId" : userID],
                encoding: JSONEncoding.default
            )
        case .unfollow:
            return .requestPlain
        }
    }
}
