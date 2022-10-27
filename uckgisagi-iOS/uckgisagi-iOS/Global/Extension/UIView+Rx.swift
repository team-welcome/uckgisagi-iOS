//
//  UIView+Rx.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import UIKit.UIView

import RxGesture
import RxSwift

public extension Reactive where Base: UIView {
    var tapGesture: Observable<Void> {
        return tapGesture { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }
        .when(.recognized)
        .map { _ in }
    }
}
