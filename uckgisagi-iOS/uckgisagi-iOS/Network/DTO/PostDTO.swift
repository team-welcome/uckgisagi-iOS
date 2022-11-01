//
//  PostDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

struct PostDTO: Decodable {
    let id: Int
    let content: String
    let isLiked: Bool
    let imageURL: String
}

extension PostDTO: Equatable, Hashable {
    static func == (lhs: PostDTO, rhs: PostDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func isSameContents(lhs: PostDTO, rhs: PostDTO) -> Bool {
        return lhs.id == rhs.id
        && lhs.content == rhs.content
        && lhs.isLiked == rhs.isLiked
        && lhs.imageURL == rhs.imageURL
    }
}
