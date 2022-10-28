//
//  UserFollowCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

import UIKit

import SnapKit

protocol UserFollowCollectionViewCellDelegate: AnyObject {
    func buttonDidTap(_ cell: UserFollowCollectionViewCell)
}

final class UserFollowCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let nameLabel = UILabel()
    private(set) lazy var button = FollowStatusButton()

    // MARK: - Properties
    weak var delegate: UserFollowCollectionViewCellDelegate?

    // MARK: - Initailize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        button.isFollowing = false
    }

    // MARK: - Function
    func configure(name: String, isFollwing: Bool) {
        nameLabel.text = name
        button.isFollowing = isFollwing
    }

    private func setProperties() {
        nameLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = Color.black
        }
        button.do {
            $0.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        }
    }

    private func setLayouts() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.width.equalTo(84)
            $0.height.equalTo(28)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(nameLabel.snp.centerY)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(button.snp.leading).offset(-12)
            $0.height.equalTo(52)
            $0.top.bottom.equalToSuperview()
        }
    }

    @objc
    private func buttonDidTap() {
        delegate?.buttonDidTap(self)
    }
}

final class FollowStatusButton: UIButton {
    public var isFollowing: Bool = false {
        didSet {
            isSelected = isFollowing
            setImage(Image.btnFollow, for: .normal)
            setImage(Image.btnFollowing, for: .selected)
        }
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
