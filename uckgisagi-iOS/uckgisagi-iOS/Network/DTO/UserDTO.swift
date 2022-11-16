//
//  UserDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

struct UserDTO: Decodable {
    let id: Int
    let nickname: String
    let followStatus: Status
    let grade: Grade

    enum CodingKeys: String, CodingKey {
        case followStatus, grade, nickname
        case id = "userId"
    }
}

extension UserDTO: Equatable, Hashable {
    static func == (lhs: UserDTO, rhs: UserDTO) -> Bool {
        return lhs.id == rhs.id
        && lhs.nickname == rhs.nickname
        && lhs.followStatus == rhs.followStatus
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(nickname)
        hasher.combine(followStatus)
    }
}

enum Status: String, Decodable {
    case active = "ACTIVE"
    case inactive = "INACTIVE"

    func parse() -> Bool {
        switch self {
        case .active:
            return true
        case .inactive:
            return false
        }
    }
}
