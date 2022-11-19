//
//  HomeReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/19.
//

import ReactorKit

class HomeReactor: Reactor {

    let initialState: State

    init() {
        initialState = State()
    }

    struct State {
        var friendList: FriendListDTO?
        var isLoading: Bool = false
    }

    enum Action {
        case getFriendList
    }

    enum Mutation {
        case setFriendList(FriendListDTO)
        case setLoading(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getFriendList:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.home.getFriendList()
                    .compactMap { $0.data }
                    .map { .setFriendList($0) },
                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setFriendList(let friendList):
            newState.friendList = friendList
        }
        
        return newState
    }

}
