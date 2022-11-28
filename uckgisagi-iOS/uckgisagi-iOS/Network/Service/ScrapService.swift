//
//  ScrapService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/28.
//

import Moya
import RxMoya
import RxSwift

protocol ScrapServiceType {
    func postScrap(postID: Int) -> Observable<BaseResponse<NullResponse>>
    func deleteScrap(postID: Int) -> Observable<BaseResponse<NullResponse>>
}

final class ScrapService: ScrapServiceType {
    private let router = MoyaProvider<ScrapRouter>(
        session: Session(interceptor: Interceptor.shared),
        plugins: [MoyaLoggingPlugin()]
    )

    func postScrap(postID: Int) -> Observable<BaseResponse<NullResponse>> {
        return router.rx.request(.postScrap(postID: postID))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }

    func deleteScrap(postID: Int) -> Observable<BaseResponse<NullResponse>> {
        return router.rx.request(.deleteScrap(postID: postID))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }


}
