//
//  LoginDTO.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/16.
//

struct LoginDTO: Decodable {
    let accessToken, nickname, refreshToken: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case accessToken, nickname, refreshToken
        case userID = "userId"
    }
}

