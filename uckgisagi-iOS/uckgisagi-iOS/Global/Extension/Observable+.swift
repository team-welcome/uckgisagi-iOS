//
//  Observable+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import Moya
import RxMoya
import RxSwift

extension Observable {
    func catchError() -> Observable<Element> {
        return self.do(onNext: { item in
            dump(item)
            guard
                let element = item as? StatusHandler,
                let status = element.statusCode
            else {
                return
            }

            if status == .unAuthorized {
                RootSwitcher.update(.login)
            }

        })
        .catch { error in
            return .empty()
        }
    }
}
