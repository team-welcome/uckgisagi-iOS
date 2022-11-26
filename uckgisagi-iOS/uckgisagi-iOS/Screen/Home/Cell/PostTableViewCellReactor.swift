//
//  UserPostTableViewCellReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import Foundation
import ReactorKit

class PostTableViewCellReactor: Reactor {
    enum Action {
        case update
    }
    
    enum Mutation {
        case setChallengePost(Post)
    }
    
    struct State {
        var challengePost: Post?
    }
    
    var initialState: State
    
    init(challengePost: Post) {
        self.initialState = State(challengePost: challengePost)
    }
}

extension PostTableViewCellReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setChallengePost(let post):
            newState.challengePost = post
        }
        
        return newState
    }
}
