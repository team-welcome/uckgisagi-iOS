//
//  PostDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

struct PostDTO: Decodable {
    let id: Int
    let content, imageURL: String
    let nickname: String?
    var scrapStatus: Status
    let createdAt,updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case content, createdAt
        case imageURL = "imageUrl"
        case nickname
        case id = "postId"
        case scrapStatus, updatedAt
    }
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
        && lhs.imageURL == rhs.imageURL
        && lhs.scrapStatus == rhs.scrapStatus
    }
}
