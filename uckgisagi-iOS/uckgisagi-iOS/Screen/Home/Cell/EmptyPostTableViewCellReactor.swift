//
//  EmptyPostTableViewCellReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import Foundation
import ReactorKit

class EmptyPostTableViewCellReactor: Reactor {
    enum EmptyPostType {
        case friend
        case my
    }
    
    enum Action {
        case tap
    }
    
    enum Mutation {}
    
    struct State {
        let type: EmptyPostType
    }
    
    var initialState: State
    
    init(type: EmptyPostType) {
        self.initialState = State(type: type)
    }
}

extension EmptyPostTableViewCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tap:
            NetworkService.shared.home.event.onNext(.pushButtonDidTap)
            return .empty()
        }
    }
}
