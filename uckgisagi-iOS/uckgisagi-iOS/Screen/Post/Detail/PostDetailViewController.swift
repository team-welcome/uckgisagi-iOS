//
//  PostDetailViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import ReactorKit

final class PostDetailViewController: BaseViewController, View {

    private let detailView = PostDetailView()

    override init() {
        super.init()
    }

    override func loadView() {
        view = detailView
    }

    func bind(reactor: PostDetailReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.post }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, post in
                owner.detailView.configure(
                    imageURL:  post.imageURL,
                    username: post.nickname ?? "",
                    timestamp: post.updatedAt ?? "",
                    content:  post.content
                )
            }
            .disposed(by: disposeBag)

    }

}
