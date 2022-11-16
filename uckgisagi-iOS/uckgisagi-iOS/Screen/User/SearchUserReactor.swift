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
    }

    enum Action {
        case search(text: String)
    }

    enum Mutation {
        case setUserList([UserDTO])
        case setLoading(Bool)
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

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUserList(userList):
            newState.userList = userList
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }

}

