//
//  NotificationRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/04.
//

import Foundation

import Moya

enum NotificationRouter {
    case poke(friendUserID: Int)
}

extension NotificationRouter: BaseTargetType {
    var path: String {
        switch self {
        case let .poke(friendUserID):
            return "/notification/\(friendUserID)/poke"
        }
    }

    var method: Moya.Method {
        switch self {
        case .poke:
            return .post
        }
    }

    var task: Task {
        return .requestPlain
    }
}
