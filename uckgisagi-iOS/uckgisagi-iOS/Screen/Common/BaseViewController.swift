//
//  BaseViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Color.white
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setProperties() { }
    func setLayouts() { }
}

extension BaseViewController {

    @objc func keyboardWillShowAnimation(height _: CGFloat, bottomPadding _: CGFloat) {}

    @objc func keyboardWillHideAnimation() {}

    func bindKeyboardNotification() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard
                    let self = self,
                    let height = self.keyboradHeight(notification: notification),
                    let duration = self.keyboardDuration(notification: notification),
                    let curve = self.keyboardCurve(notification: notification),
                    let bottomPadding = self.bottomPadding()
                else {
                    return
                }
                self.keyboardWillShowAnimation(height: height, bottomPadding: bottomPadding)
                self.view.setNeedsLayout()
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: .init(rawValue: curve),
                    animations: {
                        self.view.layoutIfNeeded()
                    }
                )
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] notification in
                guard
                    let self = self,
                    let duration = self.keyboardDuration(notification: notification),
                    let curve = self.keyboardCurve(notification: notification)
                else {
                    return
                }
                self.keyboardWillHideAnimation()
                self.view.setNeedsLayout()
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: .init(rawValue: curve),
                    animations: {
                        self.view.layoutIfNeeded()
                    }
                )
            })
            .disposed(by: disposeBag)
    }

    private func bottomPadding() -> CGFloat? {
        guard
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
        else {
            return nil
        }
        return keyWindow.safeAreaInsets.bottom
    }

    private func keyboardDuration(notification: Notification) -> TimeInterval? {
        guard
            let info = notification.userInfo,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return nil
        }
        return duration
    }

    private func keyboardCurve(notification: Notification) -> UInt? {
        guard
            let info = notification.userInfo,
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            return nil
        }
        return curve
    }

    private func keyboradHeight(notification: Notification) -> CGFloat? {
        guard
            let info = notification.userInfo,
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return nil
        }
        return keyboardFrame.height
    }
}
