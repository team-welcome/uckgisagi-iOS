//
//  UserProfileCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import UIKit

import SnapKit
import RxSwift
import ReactorKit

class UserProfileCollectionViewCell: UICollectionViewCell, View {
    typealias Reactor = UserProfileCollectionViewCellReactor
    
    var disposeBag = DisposeBag()
    
    static let identifier = "userProfileCollectionViewCell"
    private var profileNameLabel = UILabel()
    private var profileImage = UIImageView()
    private let plusImage = UIImageView()

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
        disposeBag = DisposeBag()
        
        profileNameLabel.text = nil
        profileImage.image = Image.icCircle
    }

    private func setProperties() {
        profileNameLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = Color.mediumGray
        }
        
        profileImage.do {
            $0.image = Image.icCircle
        }
        
        plusImage.do {
            $0.image = Image.icPlus
        }
    }

    private func setLayouts() {
        contentView.addSubview(profileImage)
        contentView.addSubview(profileNameLabel)
        contentView.addSubview(plusImage)
        
        profileImage.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(36)
            $0.centerX.centerY.equalToSuperview()
        }
        profileNameLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        plusImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        switch reactor.currentState.type {
        case .my:
            guard let info = reactor.currentState.info else { break }
            profileNameLabel.text = "\(info.nickname.prefix(1))"
            profileImage.image = Image.icCircleTap
            plusImage.isHidden = true
        case .friend:
            guard let info = reactor.currentState.info else { break }
            profileNameLabel.text = "\(info.nickname.prefix(1))"
            profileImage.image = Image.icCircle
            plusImage.isHidden = true
        case .plus:
            profileNameLabel.text = ""
            profileImage.image = Image.icCircleTap
            plusImage.isHidden = false
        }
    }
}
