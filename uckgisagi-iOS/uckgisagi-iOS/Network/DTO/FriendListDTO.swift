//
//  FriendListDTO.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/19.
//

import Foundation

struct FriendListDTO: Codable {
    let friendInfo: [Info]
    let myInfo: Info
}

// MARK: - Info
struct Info: Codable {
    let grade, nickname, postStatus: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case grade, nickname, postStatus
        case userID = "userId"
    }
}
