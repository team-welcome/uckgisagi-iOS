//
//  UIImageView+Kingfisher.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import UIKit.UIImageView

import Kingfisher

extension UIImageView {
    func image(url: String?, defaultImage: UIImage? = UIImage()) {
        kf.indicatorType = .activity
        guard let url = URL(string: url ?? "") else {
            image = defaultImage
            return
        }
        kf.setImage(
            with: url,
            placeholder: .none,
            options: [
                .transition(ImageTransition.fade(0.5)),
                .backgroundDecode,
                .alsoPrefetchToMemory,
                .cacheMemoryOnly
            ]
        )
    }

    func cancelDownloadTask() {
        kf.cancelDownloadTask()
    }
}
