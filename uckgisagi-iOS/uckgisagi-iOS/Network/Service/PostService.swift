//
//  PostService.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/15.
//
import UIKit.UIImage

import Moya
import RxMoya
import RxSwift

protocol PostServiceType {
    func postWriting(image: UIImage, content: String) -> Observable<BaseResponse<GradeDTO>>
    func getPostDetail(postID: Int) -> Observable<BaseResponse<PostDTO>>
    func getPostList() -> Observable<BaseArrayResponse<PostDTO>>
    func getScrapDetail(postID: Int) -> Observable<BaseResponse<PostDTO>>
    func getScrapList() -> Observable<BaseArrayResponse<PostDTO>>
    func accusePost(postId: Int) -> Observable<BaseResponse<NullResponse>>
    func blockUserPost(userId: Int) -> Observable<BaseResponse<NullResponse>>
    func delete(postID: Int) -> Observable<BaseResponse<NullResponse>>
}

final class PostService: PostServiceType {
    
    private let router = MoyaProvider<PostRouter>(
        session: Session(interceptor: Interceptor.shared),
        plugins: [MoyaLoggingPlugin()]
    )

    func postWriting(image: UIImage, content: String) -> Observable<BaseResponse<GradeDTO>> {
        return router.rx.request(.postWriting(image: image, content: content))
            .asObservable()
            .map(BaseResponse<GradeDTO>.self)
    }

    func getPostDetail(postID: Int) -> Observable<BaseResponse<PostDTO>>{
        return router.rx.request(.getPostDetail(postID: postID))
            .map(BaseResponse<PostDTO>.self)
            .asObservable()
    }

    func getPostList() -> RxSwift.Observable<BaseArrayResponse<PostDTO>> {
        return router.rx.request(.getPostList)
            .map(BaseArrayResponse<PostDTO>.self)
            .asObservable()
    }

    func getScrapDetail(postID: Int) -> RxSwift.Observable<BaseResponse<PostDTO>> {
        return router.rx.request(.getScrapDetail(postID: postID))
            .map(BaseResponse<PostDTO>.self)
            .asObservable()
    }

    func getScrapList() -> RxSwift.Observable<BaseArrayResponse<PostDTO>> {
        return router.rx.request(.getScrapList)
            .map(BaseArrayResponse<PostDTO>.self)
            .asObservable()
    }

    func accusePost(postId: Int) -> RxSwift.Observable<BaseResponse<NullResponse>> {
        return router.rx.request(.accusePost(postId: postId))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }
    
    func blockUserPost(userId: Int) -> Observable<BaseResponse<NullResponse>> {
        return router.rx.request(.blockUserPost(userid: userId))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }

    func delete(postID: Int) -> Observable<BaseResponse<NullResponse>> {
        return router.rx.request(.delete(postID: postID))
            .map(BaseResponse<NullResponse>.self)
            .asObservable()
    }
}
