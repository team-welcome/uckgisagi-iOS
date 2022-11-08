//
//  ShopListViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/31.
//

import UIKit

import ReactorKit
import RxSwift

final class ShopListViewController: BaseViewController, View {
    typealias Reactor = ShopListReactor
    private lazy var datasource = ShopListDataSource(collectionView: listView.collectionView)
    private let listView = ShopListView()

    override init() {
        super.init()
    }

    override func loadView() {
        view = listView
    }

    func bind(reactor: ShopListReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.shopList }
            .withUnretained(self)
            .bind { owner, shopList in
                owner.datasource.update(hots: shopList.hots, shops: shopList.hots)
            }
            .disposed(by: disposeBag)
    }

    func scrollToTop() {
        listView.collectionView.setContentOffset(CGPoint(x: 0, y: -16), animated: true)
    }
}
