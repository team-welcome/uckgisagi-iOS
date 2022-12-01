//
//  UserPostTableViewHeader.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/01.
//

import UIKit

import SnapKit
import RxSwift

protocol UserPostTableViewHeaderDelegate: AnyObject {
    func writeButtonDidTap(_ header: UserPostTableViewHeader)
}

class UserPostTableViewHeader: UITableViewHeaderFooterView {
    weak var delegate: UserPostTableViewHeaderDelegate?
    private let headerNoticeLabel = UILabel()
    let postButton = UIButton()
    var disposeBag = DisposeBag()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setProperties()
        setLayouts()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayouts() {
        addSubviews(headerNoticeLabel, postButton)
        
        headerNoticeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(33)
            $0.centerY.equalToSuperview()
        }
        
        postButton.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.trailing.equalToSuperview().inset(19)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setProperties() {
        headerNoticeLabel.text = "오늘은 지구를 억지로 사랑하셨나요?"
        headerNoticeLabel.textColor = Color.mediumGray
        headerNoticeLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))
        
        postButton.setImage(Image.icPost, for: .normal)
    }
    
    func bind() {
        postButton.addTarget(self, action: #selector(postButtonDidTap(_:)), for: .touchUpInside)
    }
    
    @objc func postButtonDidTap(_ sender: UIButton) {
        delegate?.writeButtonDidTap(self)
    }
}
