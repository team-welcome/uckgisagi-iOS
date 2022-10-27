//
//  NotificationManager.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import Foundation

enum NotificationCenterManager: NotificationCenterHandler {
    case example

    var name: Notification.Name {
        switch self {
        case .example:
            return Notification.Name("NotificationCenterManager.example")
        }
    }
}
