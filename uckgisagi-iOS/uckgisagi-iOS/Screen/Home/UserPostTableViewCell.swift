//
//  UserPostTableViewCell.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/01.
//

import UIKit

import SnapKit

class UserPostTableViewCell: UITableViewCell {
    static let identifier = "UserPostTableViewCell"
    private let sproutIconImage = UIImageView()
    private let textStackView = UIStackView()
    private let timeLabel = UILabel()
    private let postTextLabel = UILabel()
    private let postImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        // TODO: - 수정
        timeLabel.text = "AM 10:13"
        postTextLabel.text = "나 오늘 분리수거 잘했음"
        postImage.image = Image.postTestImage
    }
    
    func setLayouts() {
        sproutIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalTo(16)
            $0.width.equalTo(37)
            $0.height.equalTo(31)
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(sproutIconImage.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(26)
        }
        
        postImage.snp.makeConstraints {
            $0.width.equalTo(297)
            $0.height.equalTo(189)
            $0.leading.equalTo(sproutIconImage.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(26)
        }
    }
    
    func setProperties() {
        textStackView.addArrangedSubview(timeLabel)
        textStackView.addArrangedSubview(postTextLabel)
        
        contentView.addSubviews(sproutIconImage, textStackView, postImage)
        
        textStackView.spacing = 0
        textStackView.axis = .vertical
        sproutIconImage.image = Image.icSprout
        timeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        postTextLabel.font = .systemFont(ofSize: 15, weight: .regular)
        postTextLabel.textColor = Color.mediumGray
    }
}
