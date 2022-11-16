//
//  RetrieveRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/15.
//

import Moya
import Foundation

enum RetrieveRouter {
    case getPostDetail(postID: Int)
    case getPostList
    case getScrapDetail(postID: Int)
    case getScrapList
    
    case signup(fcmToken: String, socialToken: String)
}

extension RetrieveRouter: BaseTargetType {
    var path: String {
        switch self {
        case let .getPostDetail(postID):
            return "/post/\(postID)"
        case .getPostList:
            return "/post/all"
        case let .getScrapDetail(postID):
            return "/post/scrap\(postID)"
        case .getScrapList:
            return "/post/scrap"
        case .signup:
            return "/auth/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPostDetail(_), .getPostList, .getScrapDetail(_), .getScrapList:
            return .get
        case .signup(_, _):
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getPostDetail(_), .getPostList, .getScrapDetail(_), .getScrapList:
            return .requestPlain
        case .signup(let fcmToken , let socialToken):
            var params: [String: Any] = [:]
            params["fcmToken"] = fcmToken
            params["socialToken"] = socialToken
            params["socialType"] = "APPLE"
            
            let paramsJson = try? JSONSerialization.data(withJSONObject:params)
            return .requestData(paramsJson ?? Data())
        }
    }
}
