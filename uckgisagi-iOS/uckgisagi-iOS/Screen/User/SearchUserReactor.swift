//
//  SearchUserReactor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import ReactorKit

final class SearchUserReactor: Reactor {

    let initialState: State

    init() {
        initialState = State()
    }

    struct State {
        var userList: [UserDTO]?
        var isLoading: Bool = false
        var isSuccessFollow: Bool?
        var isSuccessUnfollow: Bool?
    }

    enum Action {
        case search(text: String)
        case follow(userID: Int)
        case unfollow(userID: Int)
    }

    enum Mutation {
        case setUserList([UserDTO])
        case setLoading(Bool)
        case setFollowResult(Bool)
        case setUnfollowResult(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(text):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.user.search(nickname: text)
                    .compactMap { $0.data }
                    .map { Mutation.setUserList($0)},
                Observable.just(.setLoading(false))
            ])

        case let .follow(userID):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.follow.follow(userID: userID)
                    .compactMap { $0.statusCode }
                    .map { Mutation.setFollowResult($0 == .okay) },
                Observable.just(.setLoading(false))
            ])

        case let .unfollow(userID):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.follow.unfollow(userID: userID)
                    .compactMap { $0.statusCode }
                    .map { Mutation.setUnfollowResult($0 == .okay) },
                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUserList(userList):
            newState.userList = userList
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setFollowResult(isSuccesss):
            newState.isSuccessFollow = isSuccesss
        case let .setUnfollowResult(isSuccesss):
            newState.isSuccessUnfollow = isSuccesss
        }
        return newState
    }

}

