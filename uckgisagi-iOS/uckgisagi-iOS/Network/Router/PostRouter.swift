//
//  RetrieveRouter.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/15.
//

import UIKit

import Moya
import Foundation

enum PostRouter {
    /// 챌린지 글 작성
    case postWriting(image: UIImage, content: String)
    /// 챌린지 글 상세
    case getPostDetail(postID: Int)
    /// 모든 유저의 챌린지 글 조회
    case getPostList
    /// 유저가 스크랩한 챌린지 글 조회
    case getScrapDetail(postID: Int)
    /// 유저가 스크랩한 챌린지 글 상세
    case getScrapList
    /// 게시글 신고
    case accusePost(postId: Int)
    /// 유저 차단
    case blockUserPost(userid: Int)
    /// 삭제
    case delete(postID: Int)
}

extension PostRouter: BaseTargetType {
    var path: String {
        switch self {
        case .postWriting:
            return "/post"
        case let .getPostDetail(postID):
            return "/post/\(postID)"
        case .getPostList:
            return "/post/all"
        case let .getScrapDetail(postID):
            return "/post/scrap\(postID)"
        case .getScrapList:
            return "/post/scrap"
        case .accusePost(_):
            return "/post/accuse"
        case .blockUserPost(_):
            return "/block"
        case let .delete(postID):
            return "/post/delete"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postWriting, .accusePost(_), .blockUserPost(_):
            return .post
        case .getPostDetail, .getPostList, .getScrapDetail, .getScrapList:
            return .get
        case .delete:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case let .postWriting(image, content):
            return .uploadMultipart(createMultipartFormDataList(image, content))
        case .getPostDetail(_), .getPostList, .getScrapDetail(_), .getScrapList:
            return .requestPlain
        case let .accusePost(postId):
            return .requestParameters(parameters: [
                "postId": postId
            ], encoding: JSONEncoding.default)
        case let .blockUserPost(userId):
            return .requestParameters(parameters: [
                "blockUserId": userId
            ], encoding: JSONEncoding.default)
        case let .delete(postID):
            return .requestParameters(
                parameters: ["postId": postID],
                encoding: URLEncoding.default
            )
        }
    }
}

extension PostRouter {
    func createMultipartFormDataList(_ image: UIImage, _ content: String) -> [MultipartFormData] {
        var list: [MultipartFormData] = []
        list.append(
            MultipartFormData(
                provider: .data("\(Date())".data(using: .utf8) ?? Data()),
                name: "title"
            )
        )
        list.append(
            MultipartFormData(
                provider: .data(content.data(using: .utf8) ?? Data()),
                name: "content"
            )
        )
        list.append(
            MultipartFormData(
                provider: .data(image.jpegData(compressionQuality: 0) ?? Data()),
                name: "imageFile",
                fileName: "certification.png",
                mimeType: "image/png"
            )
        )
        return list
    }
}
