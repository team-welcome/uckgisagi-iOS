//
//  StoreService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

import Moya
import RxMoya
import RxSwift

protocol StoreServiceType {
    func getStoreList() -> Observable<BaseResponse<StoreListDTO>>
}

final class StoreService: StoreServiceType {
    private let router = MoyaProvider<StoreRouter>(session: Session(interceptor: Interceptor.shared), plugins: [MoyaLoggingPlugin()])

    func getStoreList() -> Observable<BaseResponse<StoreListDTO>> {
        return router.rx.request(.getStoreList)
            .asObservable()
            .map(BaseResponse<StoreListDTO>.self)
    }
}
