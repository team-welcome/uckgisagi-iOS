//
//  SettingTableViewCell.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/01.
//

import UIKit

import SnapKit

final class SettingTableViewCell: UITableViewCell {
    private let label = UILabel()
    private var rightItem: UIView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
        setBackgroundColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        font: UIFont? = .systemFont(ofSize: 15),
        text: String,
        rightItem: UIView? = nil
    ) {
        label.text = text
        label.do {
            $0.font = font
        }

        guard let rightItem = rightItem else {
            return
        }
        contentView.addSubview(rightItem)
        rightItem.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(26)
        }
    }

    private func setLayouts() {
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(26)
        }
    }

    private func setBackgroundColor() {
        selectedBackgroundView = UIView().then {
            $0.backgroundColor = Color.lightGray.withAlphaComponent(0.3)
        }
    }

}
