//
//  PostDetailView.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import SnapKit

final class PostDetailView: UIView {
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let containerStackView = UIStackView()
    private let imageView = UIImageView()
    private let userInfoView = UIView()
    private let usernameLabel = UILabel()
    private let profileImageView = UIImageView()
    private let contentLabel = BasePaddingLabel()

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage, username: String, timestamp: String, content: String) {
        imageView.image = Image.imgDummy3
        usernameLabel.text = "\(username) \(timestamp)"
        contentLabel.text = content
    }
    
    private func setLayouts() {
        addSubviews(navigationBar, scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        scrollView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        navigationBar.addSubviews(backButton, titleLabel)
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
        }
        backButton.snp.makeConstraints {
            $0.size.equalTo(34)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(90)
        }
        containerStackView.addArrangedSubviews(imageView, userInfoView, contentLabel)
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width).multipliedBy(0.8).priority(.high)
        }
        userInfoView.addSubviews(profileImageView, usernameLabel)
        userInfoView.snp.makeConstraints {
            $0.height.equalTo(45).priority(.high)
        }
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(35)
        }
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    private func setProperties() {
        backButton.do {
            $0.setImage(Image.icBack, for: .normal)
        }
        titleLabel.do {
            $0.text = "둘러보기"
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textAlignment = .center
        }
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
        usernameLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .thin)
        }
        profileImageView.do {
            $0.image = Image.icSprout
        }
        contentLabel.do {
            $0.font = .systemFont(ofSize: 18)
            $0.numberOfLines = 0
        }
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
    }
}

fileprivate class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
