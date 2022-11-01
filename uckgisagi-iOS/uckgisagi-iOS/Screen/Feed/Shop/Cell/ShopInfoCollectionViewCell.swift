//
//  ShopInfoCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

import UIKit

import SnapKit

final class ShopInfoCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let iconView = UIImageView()
    private let dimView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(imageURL: String, title: String, content: String) {
        imageView.image = Image.imgDummy3
//        imageView.image(url: imageURL)
        titleLabel.text = title
        contentLabel.text = content
    }

    private func setProperties() {
        titleLabel.do {
            $0.font = .systemFont(ofSize: 18, weight: .medium)
            $0.textColor = Color.white
        }
        contentLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byCharWrapping
            $0.textColor = Color.white
        }
        iconView.do {
            $0.image = Image.icMark
        }
        dimView.do {
            $0.backgroundColor = Color.black.withAlphaComponent(0.8)
        }
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        contentView.cornerRadius = 16
    }

    private func setLayouts() {
        contentView.addSubviews(
            imageView,
            dimView,
            titleLabel,
            contentLabel,
            iconView
        )
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        iconView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.top.equalToSuperview().inset(12)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(iconView.snp.centerY)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.greaterThanOrEqualToSuperview().inset(4).priority(.low)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
