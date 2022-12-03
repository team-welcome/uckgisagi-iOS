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
        case updateMyPost(String)
    }
    
    enum Mutation {
        case setUserProfileSections([UserProfileSectionModel])
        case setHomeSections([HomeSectionModel])
        case setLoading(Bool)
        case setSelectedUserProfileCellIndexPath(IndexPath)
        case setSearchUserReactor(SearchUserReactor?)
        case updateUserProfileSections([UserProfileItem], IndexPath)
        case updatePostSections([HomeItem])
        case setIsPresentSearchUserVC(Bool)
        case setUserType(UserProfileCellType)
        case setFriendId(Int)
        case setPostDateList([String?])
    }
    
    struct State {
        var userProfileSections: [UserProfileSectionModel] = []
        var homeSections: [HomeSectionModel] = []
        var friendList: FriendListDTO?
        var dto: FriendListDTO?
        var isLoading: Bool = false
        var selectedUserProfileCellIndexPath: IndexPath?
        var searchUserReactor: SearchUserReactor?
        var isPresentSearchUserVC: Bool = false
        var userType: UserProfileCellType = .my
        var friendId: Int?
        var postDateList: [String?] = []
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
        case let .updateMyPost(date):
            return updatePostMutation(date: date)
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.home.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .select(date):
                let dateToString = date.dateToString()
                return this.updatePostMutation(date: dateToString)
            case .pushButtonDidTap:
                print("찌르기 버튼 이벤트 여기요 여기")
                return .empty()
            }
        }
        return Observable.merge(mutation, eventMutation)
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
            
        case let .updateUserProfileSections(items, indexPath):
            newState.userProfileSections[indexPath.section].items = items
            
        case let .setIsPresentSearchUserVC(isPresent):
            newState.isPresentSearchUserVC = isPresent
            
        case let .updatePostSections(items):
            newState.homeSections[1].items = items
            
        case let .setUserType(type):
            newState.userType = type
            
        case let .setFriendId(id):
            newState.friendId = id
            
        case let .setPostDateList(dateList):
            newState.postDateList = dateList
        }
        
        return newState
    }
    
    private func updatePostMutation(date: String) -> Observable<Mutation> {
        var updateSectionsMutation: Observable<Mutation> = .empty()
        
        switch currentState.userType {
        case .my:
            updateSectionsMutation = NetworkService.shared.home.getMyPostByDate(date: date)
                .compactMap { $0.data }
                .withUnretained(self)
                .map { this, data in
                    print(data)
                    return .setHomeSections(this.updateSections(from: data))
                    //                return .updatePostSections(this.updatePostSection(from: data))
                }
        case .friend:
            guard let friendId = currentState.friendId else { return .empty() }
            updateSectionsMutation = NetworkService.shared.home.getFriendPostByDate(friendId: friendId, date: date)
                .compactMap { $0.data }
                .withUnretained(self)
                .map { this, data in
                    print(data)
                    return .setHomeSections(this.updateSections(from: data))
                    //                return .updatePostSections(this.updatePostSection(from: data))
                }
        case .plus:
            break
        }
        
        return updateSectionsMutation
    }
    
    private func refreshMutation() -> Observable<Mutation> {
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
        print("[D] 리프레시 뮤테이션")
        print(currentState.homeSections)
        return Observable.of(.just(.setLoading(true)) , setUserProfileSectionsMutation, setMyPostSectionsMutation, .just(.setLoading(false))).merge()
    }
    
    private func tapCellMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        var setSearchUserReactorMutation: Observable<Mutation> = .empty()
        var setMyPostSectionsMutation: Observable<Mutation> = .empty()
        var updateUserProfileSelectedMutation: Observable<Mutation> = .empty()
        
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
            setSearchUserReactorMutation = .concat([.just(.setSearchUserReactor(SearchUserReactor())), .just(.setIsPresentSearchUserVC(true)), .just(.setIsPresentSearchUserVC(false))])
            break
        }
        print("[D] another button")
        
        var items = currentState.userProfileSections[indexPath.section].items.enumerated().map({ (index, item) -> UserProfileItem in
            guard case let .userProfile(reactor) = item else { return .userProfile(.init(state: .init(type: .my)))}
            var state = reactor.currentState
            if (index == indexPath.item) {
                state.isSelected = true
            } else {
                state.isSelected = false
            }
            return .userProfile(.init(state: state))
        })
        
        updateUserProfileSelectedMutation = .just(.updateUserProfileSections(items, indexPath))
        
        return Observable.of(.just(.setSelectedUserProfileCellIndexPath(indexPath)), setMyPostSectionsMutation, updateUserProfileSelectedMutation, setSearchUserReactorMutation, .just(.setFriendId(reactor.currentState.info?.userID ?? 0)), .just(.setUserType(reactor.currentState.type))).merge()
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
        calendarItems.append(.calendar(CalendarTableViewCellReactor(data: data.postDates)))
        
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
    
    private func updateSections(from data: [Post?]) -> [HomeSectionModel] {
        // TODO: - calendar 부분은 처음 정보 get할때 받아온 정보를 넣어두고, post 부분만 새롭게 넣어주고 싶은데 잘 안되는 모습. homeSection이 비어있는 경우 발생
        
//        print("[D] update post section")
//        print(currentState.homeSections)
//        var currentData = currentState.homeSections[0].items
        var calendarItems: [HomeItem] = []
        calendarItems.append(.calendar(CalendarTableViewCellReactor(data: [])))
        
//        let calendarSection: HomeSectionModel = .init(model: .calendar(currentData), items: currentData)
        let calendarSection: HomeSectionModel = .init(model: .calendar(calendarItems), items: calendarItems)
        
        var postItems: [HomeItem] = []
        if data.isEmpty {
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
            data.forEach { post in
                postItems.append(.post(.init(challengePost: post!)))
            }
        }
        
        let postSection: HomeSectionModel = .init(model: .post(postItems), items: postItems)
        
        return [calendarSection, postSection]
    }
    
    private func updatePostSection(from data: [Post?]) -> [HomeItem] {
        // TODO: post 부분만 update 하려는 방식
        var postItems: [HomeItem] = []
        if data.isEmpty {
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
            data.forEach { post in
                postItems.append(.post(.init(challengePost: post!)))
            }
        }
        return postItems
    }
}
