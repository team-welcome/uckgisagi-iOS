//
//  FeedMainViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/29.
//

import UIKit

final class FeedMainViewController: BaseViewController {
    enum PageItem {
        case following
        case scrap
        case shopList

        var text: String {
            switch self {
            case .following:
                return "둘러보기"
            case .scrap:
                return "스크랩"
            case .shopList:
                return "실천 장소 보기"
            }
        }
    }

}
