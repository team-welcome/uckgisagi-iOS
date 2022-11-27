//
//  HomeService.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/19.
//
import Foundation

import Moya
import RxMoya
import RxSwift

enum HomeEvent {
    case select(Date)
}

protocol HomeServiceType {
    var event: PublishSubject<HomeEvent> { get }
    
    func getFriendList() -> Observable<BaseResponse<FriendListDTO>>
    func getMyPost() -> Observable<BaseResponse<ChallengePostDTO>>
    func getFriendPost(friendId: Int) -> Observable<BaseResponse<ChallengePostDTO>>
}

class HomeService: HomeServiceType {
    let event = PublishSubject<HomeEvent>()
    private let router = MoyaProvider<HomeRouter>(
        session: Session(interceptor: Interceptor.shared),
        plugins: [MoyaLoggingPlugin()]
    )
    
    func getFriendList() -> RxSwift.Observable<BaseResponse<FriendListDTO>> {
        return router.rx.request(.getFriendList)
            .map(BaseResponse<FriendListDTO>.self)
            .asObservable()
    }
    
    func getFriendPost(friendId: Int) -> RxSwift.Observable<BaseResponse<ChallengePostDTO>> {
        return router.rx.request(.getFriendPost(friendId: friendId))
            .map(BaseResponse<ChallengePostDTO>.self)
            .asObservable()
    }
    
    func getMyPost() -> RxSwift.Observable<BaseResponse<ChallengePostDTO>> {
        return router.rx.request(.getMyPost)
            .map(BaseResponse<ChallengePostDTO>.self)
            .asObservable()
    }
}
