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
    
    var name: String?

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
            $0.font = .systemFont(ofSize: 18, weight: .medium)
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
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(5)
        }
        profileNameLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(profileImage)
        }
        plusImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerX.centerY.equalTo(profileImage)
        }
    }
    
    func bind(reactor: Reactor) {
        var selectedState = reactor.currentState.isSelected
        profileImage.image = selectedState ? Image.icCircleTap : Image.icCircle
    
        switch reactor.currentState.type {
        case .my:
            guard let info = reactor.currentState.info else { break }
            profileNameLabel.text = "\(info.nickname.prefix(1))"
            plusImage.isHidden = true
            name = info.nickname
        case .friend:
            guard let info = reactor.currentState.info else { break }
            profileNameLabel.text = "\(info.nickname.prefix(1))"
            plusImage.isHidden = true
            name = info.nickname
        case .plus:
            profileNameLabel.text = ""
            profileImage.image = Image.icCircleTap
            plusImage.isHidden = false
        }
    }
}
