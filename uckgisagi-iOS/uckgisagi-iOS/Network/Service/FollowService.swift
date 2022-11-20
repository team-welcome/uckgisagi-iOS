//
//  FollowService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Moya
import RxMoya
import RxSwift

protocol FollowServiceType {
    func follow(userID: Int) -> Observable<BaseResponse<NullResponse>>
    func unfollow(userID: Int) -> Observable<BaseResponse<NullResponse>>
}

final class FollowService: FollowServiceType {
    private let router = MoyaProvider<FollowRouter>(session: Session(interceptor: Interceptor()), plugins: [MoyaLoggingPlugin()])

    func follow(userID: Int) -> Observable<BaseResponse<NullResponse>>{
        return router.rx.request(.follow(userID: userID))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }

    func unfollow(userID: Int) -> Observable<BaseResponse<NullResponse>>{
        return router.rx.request(.unfollow(userID: userID))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }
}
