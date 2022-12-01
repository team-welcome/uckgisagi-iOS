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
        var isAccusing: Bool = false
        var isBlocking: Bool = false
        var userId: Int?
    }

    enum Action {
        case viewWillAppear
        case accusePost
        case blockUserPost
    }

    enum Mutation {
        case setLoading(Bool)
        case setPost(PostDTO)
        case setPostAccusing(Bool)
        case setUserPostBlocking(Bool)
        case setUserId(Int?)
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
        case .accusePost:
            return Observable.concat([
                NetworkService.shared.post.accusePost(postId: postID)
                    .filter { $0.statusCode == .accepted || $0.statusCode == .noContent || $0.statusCode == .okay }
                    .map { _ in .setPostAccusing(true) },
                Observable.just(.setPostAccusing(false))
            ])
        case .blockUserPost:
            guard let userId = currentState.userId else { return .empty() }
            return Observable.concat([
                NetworkService.shared.post.blockUserPost(userId: userId)
                    .filter { $0.statusCode == .accepted || $0.statusCode == .noContent || $0.statusCode == .okay }
                    .map { _ in .setUserPostBlocking(true) },
                Observable.just(.setUserPostBlocking(false))
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
            newState.userId = post.userId
        case let .setPostAccusing(isAccusing):
            newState.isAccusing = isAccusing
        case let .setUserPostBlocking(isBlocking):
            newState.isBlocking = isBlocking
        case let .setUserId(userId):
            newState.userId = userId
        }
        return newState
    }
}
