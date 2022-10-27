//
//  UIViewController+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import UIKit

import Photos

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
