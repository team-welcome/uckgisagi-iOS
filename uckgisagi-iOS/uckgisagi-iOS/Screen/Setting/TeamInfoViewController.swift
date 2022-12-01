//
//  TeamInfoViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/01.
//

import UIKit

final class TeamInfoViewController: BaseViewController {

    private let infoImageView = UIImageView()
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()

    override init() {
        super.init()
        bindTapAction()
    }

    override func setLayouts() {
        view.addSubviews(navigationBar, infoImageView)
        navigationBar.addSubviews(backButton, titleLabel, contentLabel)
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        infoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        backButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.leading.top.bottom.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoImageView.snp.bottom)
        }
    }

    override func setProperties() {
        infoImageView.image = Image.imgTeamInfo
        navigationBar.do {
            $0.backgroundColor = Color.white
        }
        backButton.do {
            $0.setImage(Image.icBack, for: .normal)
        }
        titleLabel.do {
            $0.text = "UCKGISAGI TEAM"
            $0.font = .systemFont(ofSize: 18, weight: .thin)
        }
        contentLabel.do {
            $0.text = "오픈소스기반기초설계 9조\nwith iksuplorer"
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.bold(targetString: "iksuplorer", targetFont: .boldSystemFont(ofSize: 16))
        }
    }

    private func bindTapAction() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

}
