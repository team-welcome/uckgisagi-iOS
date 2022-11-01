//
//  HotShopCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

import UIKit

import SnapKit

final class HotShopCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let dimView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(imageURL: String, title: String, content: String) {
        imageView.image = Image.imgDummy4
//        imageView.image(url: imageURL)
        titleLabel.text = title
        contentLabel.text = content
    }

    private func setProperties() {
        titleLabel.do {
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = Color.white
        }
        contentLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.numberOfLines = 2
            $0.textColor = Color.white
            $0.lineBreakMode = .byCharWrapping
        }
        dimView.do {
            $0.backgroundColor = Color.black.withAlphaComponent(0.8)
        }
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        contentView.cornerRadius = 18
    }

    private func setLayouts() {
        contentView.addSubviews(
            imageView,
            dimView,
            titleLabel,
            contentLabel
        )
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dimView.snp.top).offset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview().inset(12)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
