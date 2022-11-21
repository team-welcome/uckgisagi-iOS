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
    static let shared = Interceptor()

    private init() {}

    private var retryLimit = 2

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        urlRequest.setValue(
            "Bearer " + KeychainHandler.shared.accessToken,
            forHTTPHeaderField: "Authorization"
        )
        completion(.success(urlRequest))
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard
            let statusCode = request.response?.statusCode,
            request.retryCount < retryLimit,
            statusCode == 401
        else {
            return completion(.doNotRetry)
        }

        refreshToken { isSuccess in
            isSuccess ? completion(.retry) : completion(.doNotRetry)
        }
    }

    private func refreshToken(completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainHandler.shared.accessToken)"
        ]

        let parameter: Parameters = [
            "accessToken": KeychainHandler.shared.accessToken,
            "refreshToken": KeychainHandler.shared.refreshToken
        ]

        let dataTask = AF.request(
            Environment.baseURL + "/v1/auth/reissue",
            method: .post,
            parameters: parameter,
            encoding: JSONEncoding.default,
            headers: headers
        )

        dataTask.responseData { responseData in
            switch responseData.result {
            case .success:
                guard
                    let value = responseData.value,
                    let decodedData = try? JSONDecoder().decode(BaseResponse<TokenDTO>.self, from: value),
                    let statusCode = decodedData.statusCode,
                    let data = decodedData.data,
                    statusCode == .okay || statusCode == .created
                else {
                    KeychainHandler.shared.refreshToken = ""
                    KeychainHandler.shared.accessToken = ""
                    RootSwitcher.update(.login)
                    return completion(false)
                }
                dump(decodedData)

                KeychainHandler.shared.refreshToken = data.refreshToken
                KeychainHandler.shared.accessToken = data.accessToken

                completion(true)

            case .failure(_):
                KeychainHandler.shared.refreshToken = ""
                KeychainHandler.shared.accessToken = ""
                RootSwitcher.update(.login)
                completion(false)
            }

        }
    }
}
