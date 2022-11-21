//
//  HomeReactor.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/19.
//

import ReactorKit
import UIKit

class HomeReactor: Reactor {
    enum Action {
        case refesh
        case userProfileCellTap(IndexPath)
    }
    
    enum Mutation {
        case setUserProfileSections([UserProfileSectionModel])
        case setHomeSections([HomeSectionModel])
        case setLoading(Bool)
        case setSelectedUserProfileCellIndexPath(IndexPath)
        case setSearchUserReactor(SearchUserReactor?)
    }
    
    struct State {
        var userProfileSections: [UserProfileSectionModel] = []
        var homeSections: [HomeSectionModel] = []
        var friendList: FriendListDTO?
        var dto: FriendListDTO?
        var isLoading: Bool = false
        var selectedUserProfileCellIndexPath: IndexPath?
        var searchUserReactor: SearchUserReactor?
    }
    
    let initialState: State
    
    init() {
        initialState = State()
    }
}

extension HomeReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refesh:
            return refreshMutation()
            
        case let .userProfileCellTap(indexPath):
            return tapCellMutation(indexPath)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setUserProfileSections(sections):
            newState.userProfileSections = sections
            
        case let .setHomeSections(sections):
            newState.homeSections = sections
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setSelectedUserProfileCellIndexPath(indexPath):
            newState.selectedUserProfileCellIndexPath = indexPath
            
        case let .setSearchUserReactor(reactor):
            newState.searchUserReactor = reactor
        }
        
        return newState
    }
    
    private func refreshMutation() -> Observable<Mutation> {
        // homesection 업데이트하는 네트워크 로직 추가 
//        return NetworkService.shared.home.getFriendList()
//            .compactMap { $0.data }
//            .withUnretained(self)
//            .map { this, data in
//                return .setUserProfileSections(this.makeSections(from: data))
//            }
        
        let setUserProfileSectionsMutation: Observable<Mutation> = NetworkService.shared.home.getFriendList()
            .compactMap { $0.data }
            .withUnretained(self)
            .map { this, data in
                return .setUserProfileSections(this.makeSections(from: data))
            }
        
        let setMyPostSectionsMutation: Observable<Mutation> = NetworkService.shared.home.getMyPost()
            .compactMap { $0.data }
            .withUnretained(self)
            .map { this, data in
                return .setHomeSections(this.makeSections(from: data))
            }
        
        return Observable.of(setUserProfileSectionsMutation, setMyPostSectionsMutation).merge()
    }
    
    private func tapCellMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        print("[D] 셀이 클릭됨 \(indexPath)")
        var setSearchUserReactorMutation: Observable<Mutation> = .empty()
        var setMyPostSectionsMutation: Observable<Mutation> = .empty()
        
        guard case let .userProfile(reactor) = currentState.userProfileSections[indexPath.section].items[indexPath.item] else { return .empty() }
        switch reactor.currentState.type {
        case .my:
            setMyPostSectionsMutation = NetworkService.shared.home.getMyPost()
                .compactMap { $0.data }
                .withUnretained(self)
                .map { this, data in
                    return .setHomeSections(this.makeSections(from: data))
                }
            break
        case .friend:
            guard let id = reactor.currentState.info?.userID else { return .empty() }
            setMyPostSectionsMutation = NetworkService.shared.home.getFriendPost(friendId: id)
                .compactMap { $0.data }
                .withUnretained(self)
                .map { this, data in
                    return .setHomeSections(this.makeSections(from: data))
                }
            break
        case .plus:
//            setSearchUserReactorMutation = .concat([.just(.setSearchUserReactor(SearchUserReactor())), .just(.setSearchUserReactor(SearchUserReactor()))])
            setSearchUserReactorMutation = .just(.setSearchUserReactor(SearchUserReactor()))
            break
        }
        
        return Observable.of(.just(.setSelectedUserProfileCellIndexPath(indexPath)), setMyPostSectionsMutation).merge()
    }
    
    private func makeSections(from data: FriendListDTO) -> [UserProfileSectionModel] {
        var items: [UserProfileItem] = []
        
        items.append(UserProfileItem.userProfile(UserProfileCollectionViewCellReactor(state: .init(type: .my, info: data.myInfo))))
        data.friendInfo?.forEach({ (info) in
            items.append(UserProfileItem.userProfile(UserProfileCollectionViewCellReactor(state: .init(type: .friend, info: info))))
            
        })
        items.append(UserProfileItem.userProfile(UserProfileCollectionViewCellReactor(state: .init(type: .plus))))
        
        let section: UserProfileSectionModel = .init(model: .userProfile(items), items: items)
        
        return [section]
    }
    
    private func makeSections(from data: ChallengePostDTO) -> [HomeSectionModel] {
        var calendarItems: [HomeItem] = []
        calendarItems.append(.calendar(CalendarTableViewCellReactor(data: [])))
        
        let calendarSection: HomeSectionModel = .init(model: .calendar(calendarItems), items: calendarItems)
        
        var postItems: [HomeItem] = []
        if data.posts.isEmpty {
            if let indexPath = currentState.selectedUserProfileCellIndexPath {
                guard case let .userProfile(reactor) = currentState.userProfileSections[indexPath.section].items[indexPath.item] else { return [] }
                switch reactor.currentState.type {
                case .my:
                    postItems.append(.emptyPost(EmptyPostTableViewCellReactor(type: .my)))
                case .friend:
                    postItems.append(.emptyPost(EmptyPostTableViewCellReactor(type: .friend)))
                default:
                    break
                }
            } else {
                postItems.append(.emptyPost(EmptyPostTableViewCellReactor(type: .my)))
            }
        } else {
            data.posts.forEach { post in
                postItems.append(.post(.init(challengePost: post)))
            }
        }
        
        let postSection: HomeSectionModel = .init(model: .post(postItems), items: postItems)
        
        return [calendarSection, postSection]
    }
}
