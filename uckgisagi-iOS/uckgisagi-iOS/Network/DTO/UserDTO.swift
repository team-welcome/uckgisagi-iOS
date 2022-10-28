//
//  UserDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let isFollowing: Bool
}

extension UserDTO: Equatable, Hashable {
    static func == (lhs: UserDTO, rhs: UserDTO) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.isFollowing == rhs.isFollowing
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(isFollowing)
    }
}
