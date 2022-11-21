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
}

final class PostService: PostServiceType {
    
    private let router = MoyaProvider<PostRouter>(session: Session(interceptor: Interceptor.shared), plugins: [MoyaLoggingPlugin()])

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

}
