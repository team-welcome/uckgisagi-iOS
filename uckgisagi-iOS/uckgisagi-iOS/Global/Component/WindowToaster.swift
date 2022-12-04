//
//  WindowToaster.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/04.
//

import Foundation

import UIKit

final class WindowToaster {

    static let shared = WindowToaster()

    private init() { }

    func showToaster(text: String) {
        guard let window = UIApplication.findWindow() else { return }
        let toasterLabel = UILabel()
        toasterLabel.textColor = Color.white
        toasterLabel.text = text
        toasterLabel.font = .systemFont(ofSize: 14)
        toasterLabel.numberOfLines = 2
        toasterLabel.textAlignment = .center

        let toasterView = UIView()
        toasterView.backgroundColor = Color.black.withAlphaComponent(0.9)
        toasterView.clipsToBounds = true
        toasterView.cornerRadius = 20

        window.addSubview(toasterView)
        toasterView.addSubview(toasterLabel)
        toasterLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        toasterView.snp.makeConstraints {
            $0.leading.trailing.equalTo(window.safeAreaLayoutGuide).inset(10)
            $0.top.equalTo(window.safeAreaLayoutGuide).offset(-60)
        }

        UIView.animate(withDuration: 0.5) {
            toasterView.transform = CGAffineTransform(translationX: 0, y: 70)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0) {
                toasterView.transform = CGAffineTransform(translationX: 0, y: -60)
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toasterLabel.removeFromSuperview()
                    toasterView.removeFromSuperview()
                }
            }
        }
    }
}

extension UIApplication {
    class func findWindow() -> UIWindow? {
         if #available(iOS 13, *) {
             return shared.connectedScenes
                 .compactMap { $0 as? UIWindowScene }
                 .flatMap { $0.windows }
                 .first { $0.isKeyWindow }
         } else {
             return shared.keyWindow
         }
     }
}
