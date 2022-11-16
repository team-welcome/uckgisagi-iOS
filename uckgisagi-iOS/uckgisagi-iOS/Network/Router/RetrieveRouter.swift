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
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPostDetail(_), .getPostList, .getScrapDetail(_), .getScrapList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getPostDetail(_), .getPostList, .getScrapDetail(_), .getScrapList:
            return .requestPlain
        }
    }
}
