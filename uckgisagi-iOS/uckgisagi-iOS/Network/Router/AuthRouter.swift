//
//  AuthRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Foundation

import Moya

enum AuthRouter {
    case signup(fcmToken: String, socialToken: String)
}

extension AuthRouter: BaseTargetType {
    var path: String {
        switch self {
        case .signup:
            return "/auth/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signup(_, _):
            return .post
        }
    }

    var task: Task {
        switch self {
        case .signup(let fcmToken , let socialToken):
            var params: [String: Any] = [:]
            params["fcmToken"] = fcmToken
            params["socialToken"] = socialToken
            params["socialType"] = "APPLE"

            let paramsJson = try? JSONSerialization.data(withJSONObject: params)
            return .requestData(paramsJson ?? Data())
        }
    }
}
