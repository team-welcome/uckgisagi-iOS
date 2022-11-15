//
//  PostDetailViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import ReactorKit

final class PostDetailViewController: BaseViewController {

    private let detailView = PostDetailView()

    override init() {
        super.init()
    }

    override func loadView() {
        view = detailView
    }

    override func setProperties() {
        detailView.configure(
            image: Image.imgDummy3,
            username: "재연",
            timestamp: "AM 10:13",
            content:  "라벨 꼭 떼고 버리자 애들아 🌱"
        )
    }

}
