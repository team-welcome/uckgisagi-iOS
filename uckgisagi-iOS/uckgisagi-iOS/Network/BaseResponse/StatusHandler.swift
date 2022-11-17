//
//  StatusHandler.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

protocol StatusHandler {
    var statusCode: StatusCode? { get }
    var message: String? { get }
}
