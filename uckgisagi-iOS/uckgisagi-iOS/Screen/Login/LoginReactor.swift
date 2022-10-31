//
//  LoginReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import Foundation

import ReactorKit

class LoginReactor: Reactor {
    enum Action {
        case doLogin
    }
    
    enum Mutation {
        case doAppleLogin(Bool)
    }
    
    struct State {
        var isAppleLoginSuccess: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .doLogin:
            return Observable.concat([
                Observable.just(.doAppleLogin(true)),
                Observable.just(.doAppleLogin(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .doAppleLogin(let status):
            newState.isAppleLoginSuccess = status
        }
        
        return newState
    }
}
