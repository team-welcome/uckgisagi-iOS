//
//  NotificationService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/04.
//

import Moya
import RxMoya
import RxSwift

protocol NotificationServiceType {
    func poke(friendUserID: Int) -> Observable<BaseResponse<NullResponse>>
}

final class NotificationService: NotificationServiceType {
    private let router = MoyaProvider<NotificationRouter>(
        session: Session(interceptor: Interceptor.shared),
        plugins: [MoyaLoggingPlugin()]
    )

    func poke(friendUserID: Int) -> Observable<BaseResponse<NullResponse>> {
        return router.rx.request(.poke(friendUserID: friendUserID))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }
}
