//
//  CalendarTableViewCellReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import Foundation
import ReactorKit

class CalendarTableViewCellReactor: Reactor {
    enum Action {
        case selectDate(Date)
    }
    
    enum Mutation {
    }
    
    struct State {
        var dates: [String]
    }
    
    var initialState: State
    
    init(data: [String?]) {
        var dates: [String] = []
        
        data.forEach({ (str) in
            if let str = str {
                dates.append(str)
            }
        })
        self.initialState = State(dates: dates)
    }
}

extension CalendarTableViewCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectDate(date):
            NetworkService.shared.home.event.onNext(.select(date))
            return .empty()
        }
    }
}
