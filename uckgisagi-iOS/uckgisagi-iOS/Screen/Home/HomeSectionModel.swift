//
//  HomeSectionModel.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import Foundation

import RxDataSources

typealias HomeSectionModel = SectionModel<HomeSection, HomeItem>

enum HomeSection {
    case calendar([HomeItem])
    case post([HomeItem])
}

enum HomeItem {
    case calendar(CalendarTableViewCellReactor)
    case post(PostTableViewCellReactor)
    case emptyPost(EmptyPostTableViewCellReactor)
}

extension HomeSection: SectionModelType {
    typealias Item = HomeItem
    
    var items: [Item] {
        switch self {
        case let .calendar(items):
            return items
            
        case let .post(items):
            return items
        }
    }
    
    init(original: HomeSection, items: [HomeItem]) {
        switch original {
        case let .calendar(items):
            self = .calendar(items)
            
        case let .post(items):
            self = .post(items)
        }
    }
}

