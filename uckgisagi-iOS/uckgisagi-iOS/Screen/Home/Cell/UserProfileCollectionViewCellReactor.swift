//
//  UserProfileCellReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import Foundation
import ReactorKit

class UserProfileCollectionViewCellReactor: Reactor {
    enum UserProfileCellType {
        case my
        case friend
        case plus
    }
    
    enum Action {
        case tap
        case update
    }
    
    enum Mutation {
        case updateIsSelected
        case updateDto(FriendListDTO)
    }
    
    struct State {
        var type: UserProfileCellType
        var info: Info?
        var dto: FriendListDTO?
        var isSelected: Bool = false
    }
    
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}

extension UserProfileCollectionViewCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tap:
            return tapMutation()
        case .update:
            return .just(.updateIsSelected)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateIsSelected:
            newState.isSelected.toggle()
            
        case let .updateDto(dto):
            newState.dto = dto
        }
        
        return newState
    }
    
    private func tapMutation() -> Observable<Mutation> {
        // 서버 로직
        
        return .just(.updateDto(.init(friendInfo: [], myInfo: Info(grade: "", nickname: "", postStatus: "", userID: 0))))
    }
}
