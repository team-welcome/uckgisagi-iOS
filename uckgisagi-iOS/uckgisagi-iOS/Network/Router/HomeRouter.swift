//
//  HomeRouter.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/19.
//

import Foundation

import Moya

enum HomeRouter {
    case getFriendList
    case getFriendPost(friendId: Int)
    case getMyPost
    case getMyPostByDate(date: String)
    case getFriendPostByDate(friendId: Int, date: String)
}

extension HomeRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getFriendList:
            return "/home/user"
        case let .getFriendPost(friendId):
            return "/home/\(friendId)"
        case .getMyPost:
            return "/home/me"
        case .getMyPostByDate(_):
            return "/home/me/post"
        case let .getFriendPostByDate(friendId, _):
            return "/home/\(friendId)/post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFriendList, .getFriendPost(_), .getMyPost, .getMyPostByDate(_), .getFriendPostByDate(_, _):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFriendList, .getFriendPost(_), .getMyPost:
            return .requestPlain
        case let .getMyPostByDate(date):
            return .requestParameters(
                parameters: [
                    "date": date
                ], encoding: URLEncoding.default)
        case let .getFriendPostByDate(_, date):
            return .requestParameters(
                parameters: [
                    "date": date
                ], encoding: URLEncoding.default)
        }
    }
    
}
