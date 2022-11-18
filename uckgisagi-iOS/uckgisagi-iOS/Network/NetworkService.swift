//
//  NetworkService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

final class NetworkService {
    static let shared = NetworkService()

    let auth = AuthService()
    let post = PostService()
    let store = StoreService()
    let user = UserService()
    let follow = FollowService()
}
