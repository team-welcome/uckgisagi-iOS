//
//  Observable+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import RxSwift

extension Observable {
    func catchError() -> Observable<Element> {
        return self.do(onNext: { item in
            guard
                let element = item as? StatusHandler,
                let status = element.statusCase
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
