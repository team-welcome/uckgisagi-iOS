//
//  PostListViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/29.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class PostListViewController: BaseViewController, View {
    enum Section {
        case main
    }

    private let listView = PostListView()

    private lazy var dataSource = PostListDataSource(collectionView: listView.collectionView)

    override func loadView() {
        view = listView
    }

    func bind(reactor: PostListReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.posts }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, posts in
                owner.dataSource.update(posts: posts)
            }
            .disposed(by: disposeBag)

        listView.collectionView.rx.itemSelected
            .withUnretained(self)
            .map { owner, indexPath in
                return owner.dataSource.itemIdentifier(for: indexPath)
            }
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                let detail = PostDetailViewController()
                detail.reactor = PostDetailReactor(postID: item.id)
                detail.modalPresentationStyle = .fullScreen
                owner.navigationController?.pushViewController(detail, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func scrollToTop() {
        listView.collectionView.setContentOffset(CGPoint(x: 0, y: -16), animated: true)
    }
}
