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
    
    enum Action {}
    
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
    
}
