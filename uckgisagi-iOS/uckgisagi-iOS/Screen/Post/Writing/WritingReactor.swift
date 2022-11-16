//
//  WritingReactor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import ReactorKit

final class WritingReactor: Reactor {
    struct State {
        var isLoading: Bool = true
    }

    enum Action {
        case finishWriting(text: String, image: UIImage)
    }

    enum Mutation {
        case setLoading(Bool)
    }

    let initialState: State

    init() {
        initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .finishWriting(text, image):
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.post.postWriting(image: image, content: text)
                    .compactMap { $0.data }
                    .map { _ in Mutation.setLoading(false)}
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
