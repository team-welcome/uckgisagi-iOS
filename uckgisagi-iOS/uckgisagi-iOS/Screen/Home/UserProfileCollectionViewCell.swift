//
//  UserProfileCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import UIKit

import SnapKit

class UserProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "userProfileCollectionViewCell"
    private var profileNameLabel = UILabel()
    private var profileImage = UIImageView()

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
        profileNameLabel.text = nil
        profileImage.image = Image.icCircle
    }

    // MARK: - Function
    func configure(name: String, isFriend: Bool) {
        profileNameLabel.text = name
        profileImage.image = isFriend ? Image.icCircle : Image.icCircleTap
    }

    private func setProperties() {
        profileNameLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = Color.mediumGray
        }
        
        profileImage.do {
            $0.image = Image.icCircle
        }
    }

    private func setLayouts() {
        contentView.addSubview(profileImage)
        contentView.addSubview(profileNameLabel)
        profileImage.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(36)
//            $0.leading.trailing.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
        profileNameLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
