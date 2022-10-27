//
//  UIStackView+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import UIKit.UIStackView

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
