//
//  Interceptor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/20.
//

import Foundation

import Alamofire
import Moya
import RxSwift

final class Interceptor : RequestInterceptor {
    private let disposeBag = DisposeBag()

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401
        else {
            completion(.doNotRetry)
            return
        }

        NetworkService.shared.auth.reissue()
            .subscribe(onNext: { response in
                guard
                    let accessToken = response.data?.accessToken,
                    let refreshToken = response.data?.refreshToken
                else {
                    KeychainHandler.shared.removeAll()
                    UserDefaultHandler.shared.removeAll()
                    RootSwitcher.update(.login)
                    return completion(.doNotRetry)
                }
                KeychainHandler.shared.accessToken = accessToken
                KeychainHandler.shared.refreshToken = refreshToken
                completion(.retryWithDelay(0.1))
            })
            .disposed(by: disposeBag)
    }

}
