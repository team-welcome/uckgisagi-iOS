//
//  StoreRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Foundation

import Moya

enum StoreRouter {
    case getStoreList
}

extension StoreRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getStoreList:
            return "/store"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStoreList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getStoreList:
            return .requestPlain
        }
    }
}
