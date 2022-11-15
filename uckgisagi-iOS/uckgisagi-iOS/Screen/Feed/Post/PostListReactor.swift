//
//  PostListReactor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/31.
//

import ReactorKit

final class PostListReactor: Reactor {
    enum ReactorType {
        case all
        case scrap
    }

    let initialState: State

    private let type: ReactorType

    init(type: ReactorType) {
        self.type = type
        initialState = State()
    }

    struct State {
        var posts: [PostDTO]?
        var isLoading: Bool = false
    }

    enum Action {
        case viewWillAppear
        case pullToRefresh
    }

    enum Mutation {
        case setPosts(posts:[PostDTO])
        case setLoading(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .pullToRefresh:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.setPosts(
                    posts: []
                )),
                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setPosts(posts):
            newState.posts = posts
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }

}
