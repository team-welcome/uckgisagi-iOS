//
//  AuthService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Moya
import RxMoya
import RxSwift

protocol AuthServiceType {
    func signup(fcmToken: String, socialToken: String) -> Observable<BaseResponse<LoginDTO>>
    func reissue() -> Observable<BaseResponse<TokenDTO>>
}

final class AuthService: AuthServiceType {
    private let router = MoyaProvider<AuthRouter>(session: Session(interceptor: Interceptor()), plugins: [MoyaLoggingPlugin()])

    func signup(fcmToken: String, socialToken: String) -> Observable<BaseResponse<LoginDTO>> {
        return router.rx.request(.signup(fcmToken: fcmToken, socialToken: socialToken))
            .map(BaseResponse<LoginDTO>.self)
            .asObservable()
            .catchError()
    }

    func reissue() -> Observable<BaseResponse<TokenDTO>> {
        return router.rx.request(.reissue)
            .map(BaseResponse<TokenDTO>.self)
            .asObservable()
            .catchError()
    }
}
