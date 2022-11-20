//
//  PostDetailReactor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/20.
//

import UIKit

import ReactorKit

final class PostDetailReactor: Reactor {
    private let postID: Int

    struct State {
        var isLoading: Bool = true
        var post: PostDTO?
    }

    enum Action {
        case viewWillAppear
    }

    enum Mutation {
        case setLoading(Bool)
        case setPost(PostDTO)
    }

    let initialState: State

    init(postID: Int) {
        self.postID = postID
        initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.post.getPostDetail(postID: postID)
                    .compactMap { $0.data }
                    .map { Mutation.setPost($0) },
                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setPost(post):
            newState.post = post
        }
        return newState
    }
}
