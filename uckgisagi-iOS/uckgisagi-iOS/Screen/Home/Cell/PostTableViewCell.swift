//
//  UserPostTableViewCell.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/01.
//

import UIKit

import SnapKit
import ReactorKit

class PostTableViewCell: UITableViewCell, View {
    typealias Reactor = PostTableViewCellReactor
    
    var disposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
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
            $0.height.equalTo(189)
            $0.leading.equalTo(sproutIconImage.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(26)
            $0.top.equalTo(textStackView.snp.bottom).offset(16)
        }
    }
    
    func setProperties() {
        textStackView.addArrangedSubview(timeLabel)
        textStackView.addArrangedSubview(postTextLabel)
        
        contentView.addSubviews(sproutIconImage, textStackView, postImage)
        
        textStackView.spacing = 3
        textStackView.axis = .vertical
        sproutIconImage.image = Image.icSprout
        timeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        postTextLabel.font = .systemFont(ofSize: 15, weight: .regular)
        postTextLabel.textColor = Color.mediumGray
        postImage.layer.cornerRadius = 10
        postImage.layer.masksToBounds = true
    }
    
    func bind(reactor: Reactor) {
        guard let post = reactor.currentState.challengePost else { return }
        let postDate = getDate(str: post.createdAt)
        
        timeLabel.text = postDate
        postTextLabel.text = post.content
        
        if let imageURL = URL(string: post.imageURL) {
            postImage.kf.setImage(with: imageURL)
        }
    }
    
    func getDate(str: String) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: str)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        let finalDate = dateFormatter.string(from: date)

        return finalDate
    }
}
