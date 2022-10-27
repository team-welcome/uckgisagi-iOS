//
//  StatusHandler.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

protocol StatusHandler {
    var statusCase: StatusCase? { get }
    var message: String? { get }
}
