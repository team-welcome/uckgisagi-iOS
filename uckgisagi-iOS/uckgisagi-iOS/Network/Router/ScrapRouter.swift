//
//  ScrapRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/28.
//

import Foundation

import Moya

enum ScrapRouter {
    case postScrap(postID: Int)
    case deleteScrap(postID: Int)
}

extension ScrapRouter: BaseTargetType {
    var path: String {
        switch self {
        case let .postScrap(postId):
            return "/scrap/\(postId)"
        case let .deleteScrap(postID):
            return "/scrap/\(postID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postScrap:
            return .post
        case .deleteScrap:
            return .delete
        }
    }

    var task: Task {
        return .requestPlain
    }

}
