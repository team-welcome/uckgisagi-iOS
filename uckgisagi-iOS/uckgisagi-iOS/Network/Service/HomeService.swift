//
//  HomeService.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/19.
//

import Moya
import RxMoya
import RxSwift

protocol HomeServiceType {
    func getFriendList() -> Observable<BaseResponse<FriendListDTO>>
}

class HomeService: HomeServiceType {
    private let router = MoyaProvider<HomeRouter>(plugins: [MoyaLoggingPlugin()])
    
    func getFriendList() -> Observable<BaseResponse<FriendListDTO>> {
        return router.rx.request(.getFriendList)
            .map(BaseResponse<FriendListDTO>.self)
            .asObservable()
            .catchError()
    }
}
