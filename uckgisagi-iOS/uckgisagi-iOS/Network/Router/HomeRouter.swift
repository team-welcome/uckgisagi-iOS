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
}

extension HomeRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getFriendList:
            return "/home/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFriendList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFriendList:
            return .requestPlain
        }
    }
    
}
