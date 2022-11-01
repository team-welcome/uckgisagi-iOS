//
//  ShopHeaderView.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

import UIKit

import SnapKit

final class ShopHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(text: String) {
        titleLabel.text = text
    }

    private func setProperties() {
        titleLabel.do {
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textColor = Color.green
        }
    }

    private func setLayouts() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
