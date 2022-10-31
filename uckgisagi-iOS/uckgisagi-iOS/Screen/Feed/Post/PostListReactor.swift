//
//  PostListReactor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/31.
//

import ReactorKit

struct PostDTO: Decodable {
    let id: Int
    let content: String
    let isLiked: Bool
    let imageURL: String
}

extension PostDTO: Equatable, Hashable {
    static func == (lhs: PostDTO, rhs: PostDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func isSameContents(lhs: PostDTO, rhs: PostDTO) -> Bool {
        return lhs.id == rhs.id
        && lhs.content == rhs.content
        && lhs.isLiked == rhs.isLiked
        && lhs.imageURL == rhs.imageURL
    }
}

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
                    posts: [
                        PostDTO(
                            id: 1,
                            content: "나 오늘 분리수거 잘함. 라벨 꼭 떼고 버리기",
                            isLiked: false,
                            imageURL: "https://user-images.githubusercontent.com/103497527/193805545-93e46588-7013-4310-aa60-ecb4c2f3312c.png"
                        ),
                        PostDTO(
                            id: 2,
                            content: "나 오늘 분리수거 잘함. 라벨 꼭 떼고 버리기",
                            isLiked: true,
                            imageURL: "https://user-images.githubusercontent.com/103497527/193805545-93e46588-7013-4310-aa60-ecb4c2f3312c.png"
                        ),
                        PostDTO(
                            id: 3,
                            content: "나 오늘 분리수거 잘함. 라벨 꼭 떼고 버리기",
                            isLiked: false,
                            imageURL: "https://user-images.githubusercontent.com/103497527/193805545-93e46588-7013-4310-aa60-ecb4c2f3312c.png"
                        ),
                        PostDTO(
                            id: 4,
                            content: "나 오늘 분리수거 잘함. 라벨 꼭 떼고 버리기",
                            isLiked: true,
                            imageURL: "https://user-images.githubusercontent.com/103497527/193805545-93e46588-7013-4310-aa60-ecb4c2f3312c.png"
                        )
                    ]
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
