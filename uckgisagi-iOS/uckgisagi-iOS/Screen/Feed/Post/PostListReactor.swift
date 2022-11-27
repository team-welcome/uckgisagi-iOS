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
        var isSuccessPostScrap: Bool?
        var isSuccessDeleteScrap: Bool?
    }

    enum Action {
        case viewWillAppear
        case pullToRefresh
        case scrap(postID: Int)
        case deleteScrap(postID: Int)
    }

    enum Mutation {
        case setPosts(posts:[PostDTO])
        case setLoading(Bool)
        case setPostScrapResult(Bool)
        case setDeleteScrapResult(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        let getPostList = type == .all
        ? NetworkService.shared.post.getPostList()
        : NetworkService.shared.post.getScrapList()

        switch action {
        case .viewWillAppear, .pullToRefresh:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                getPostList.compactMap { Mutation.setPosts(posts: $0.data ?? []) },
                Observable.just(.setLoading(false))
            ])

        case let .scrap(postID):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.scrap.postScrap(postID: postID)
                    .compactMap { $0.statusCode }
                    .map { Mutation.setPostScrapResult($0 == .okay) },
                Observable.just(.setLoading(false))
            ])

        case let .deleteScrap(postID):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.scrap.deleteScrap(postID: postID)
                    .compactMap { $0.statusCode }
                    .map { Mutation.setDeleteScrapResult($0 == .okay) },
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
        case let .setPostScrapResult(isSuccess):
            newState.isSuccessPostScrap = isSuccess
        case let .setDeleteScrapResult(isSuccess):
            newState.isSuccessDeleteScrap = isSuccess
        }
        return newState
    }

}
