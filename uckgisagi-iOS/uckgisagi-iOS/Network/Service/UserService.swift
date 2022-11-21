//
//  UserService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Moya
import RxMoya
import RxSwift

protocol UserServiceType {
    func search(nickname: String) -> Observable<BaseArrayResponse<UserDTO>>
}

final class UserService: UserServiceType {
    private let router = MoyaProvider<UserRouter>(session: Session(interceptor: Interceptor.shared), plugins: [MoyaLoggingPlugin()])

    func search(nickname: String) -> Observable<BaseArrayResponse<UserDTO>> {
        return router.rx.request(.search(nickname: nickname))
            .map(BaseArrayResponse<UserDTO>.self)
            .asObservable()
    }
}
