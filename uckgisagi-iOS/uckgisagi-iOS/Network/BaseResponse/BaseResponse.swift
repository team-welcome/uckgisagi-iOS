//
//  BaseResponse.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

struct BaseResponse<T: Decodable>: Decodable, StatusHandler {
    let statusCase: StatusCase?
    let message: String?
    let data: T?
}
