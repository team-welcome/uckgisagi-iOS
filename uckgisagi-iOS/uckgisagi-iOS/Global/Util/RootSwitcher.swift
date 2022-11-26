//
//  RootSwitcher.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/27.
//

import UIKit
import RxSwift

final class RootSwitcher {
    enum Destination {
        case splash
        case login
        case home
        case custom(UIViewController)
    }

    static func update(_ destination: Destination) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            return
        }
        switch destination {
        case .splash:
            delegate.window?.rootViewController = SplashViewController()
        case .login:
            delegate.window?.rootViewController = LoginViewController()
        case .home:
            let homeViewController = HomeViewController()
            homeViewController.reactor = HomeReactor()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            delegate.window?.rootViewController = navigationController
            navigationController.navigationBar.isHidden = true
            
        /// 테스트에만 사용할것
        case let .custom(viewController):
            delegate.window?.rootViewController = viewController
        }
    }
}
