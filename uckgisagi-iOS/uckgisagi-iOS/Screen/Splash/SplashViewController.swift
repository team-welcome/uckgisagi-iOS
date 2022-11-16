//
//  SplashViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/02.
//

import UIKit

import SnapKit

final class SplashViewController: BaseViewController {
    private let logoImageView = UIImageView().then {
        $0.image = Image.bigLogo
        $0.contentMode = .scaleAspectFit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RootSwitcher.update(.home)
        }
    }

    override func setLayouts() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
