//
//  UserProfileSectionModel.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import RxDataSources

typealias UserProfileSectionModel = SectionModel<UserProfileSection, UserProfileItem>

enum UserProfileSection {
    case userProfile([UserProfileItem])
}

enum UserProfileItem {
    case userProfile(UserProfileCollectionViewCellReactor)
}

extension UserProfileSection: SectionModelType {
    typealias Item = UserProfileItem
    
    var items: [Item] {
        switch self {
        case let .userProfile(items):
            return items
        }
    }
    
    init(original: UserProfileSection, items: [UserProfileItem]) {
        switch original {
        case let .userProfile(items):
            self = .userProfile(items)
        }
    }
}
