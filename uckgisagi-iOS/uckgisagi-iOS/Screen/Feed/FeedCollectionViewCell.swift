//
//  FeedCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/31.
//

import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let heartButton = UIButton()
    private let dimView = UIView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    private func setProperties() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        heartButton.do {
            $0.setImage(Image.imgAddUser, for: .selected)
            $0.setImage(Image.appleLogo, for: .normal)
        }
        dimView.do {
            $0.backgroundColor = Color.black.withAlphaComponent(0.5)
        }
        titleLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = Color.white
        }
    }

    private func setLayouts() {
        contentView.addSubviews(
            imageView,
            dimView,
            heartButton,
            titleLabel
        )
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        heartButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
