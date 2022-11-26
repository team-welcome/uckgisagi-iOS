//
//  ChallengePostDTO.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/20.
//

import Foundation

struct ChallengePostDTO: Codable {
    let postDates: [String?]
    let posts: [Post]
}

// MARK: - Post
struct Post: Codable {
    let content, createdAt, imageURL: String
    let postID: Int
    let title, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case content, createdAt
        case imageURL = "imageUrl"
        case postID = "postId"
        case title, updatedAt
    }
}
