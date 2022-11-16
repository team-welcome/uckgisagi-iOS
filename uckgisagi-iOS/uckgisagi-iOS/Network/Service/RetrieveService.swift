//
//  RetrieveService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/15.
//

import Moya
import RxMoya
import RxSwift

protocol RetrieveServiceType {
    func getPostDetail(postID: Int) -> Observable<BaseResponse<PostDTO>>
    func getPostList() -> Observable<BaseArrayResponse<PostDTO>>
    func getScrapDetail(postID: Int) -> Observable<BaseResponse<PostDTO>>
    func getScrapList() -> Observable<BaseArrayResponse<PostDTO>>
    
    func signup(fcmToken: String, socialToken: String) -> Observable<BaseResponse<LoginDTO>>
}

final class RetrieveService: RetrieveServiceType {
    
    private let router = MoyaProvider<RetrieveRouter>(plugins: [MoyaLoggingPlugin()])

    func getPostDetail(postID: Int) -> Observable<BaseResponse<PostDTO>>{
        return router.rx.request(.getPostDetail(postID: postID))
            .map(BaseResponse<PostDTO>.self)
            .asObservable()
            .catchError()
    }

    func getPostList() -> RxSwift.Observable<BaseArrayResponse<PostDTO>> {
        return router.rx.request(.getPostList)
            .map(BaseArrayResponse<PostDTO>.self)
            .asObservable()
            .catchError()
    }

    func getScrapDetail(postID: Int) -> RxSwift.Observable<BaseResponse<PostDTO>> {
        return router.rx.request(.getScrapDetail(postID: postID))
            .map(BaseResponse<PostDTO>.self)
            .asObservable()
            .catchError()
    }

    func getScrapList() -> RxSwift.Observable<BaseArrayResponse<PostDTO>> {
        return router.rx.request(.getScrapList)
            .map(BaseArrayResponse<PostDTO>.self)
            .asObservable()
            .catchError()
    }
    
    func signup(fcmToken: String, socialToken: String) -> RxSwift.Observable<BaseResponse<LoginDTO>> {
        return router.rx.request(.signup(fcmToken: fcmToken, socialToken: socialToken))
            .map(BaseResponse<LoginDTO>.self)
            .asObservable()
            .catchError()
    }
}
