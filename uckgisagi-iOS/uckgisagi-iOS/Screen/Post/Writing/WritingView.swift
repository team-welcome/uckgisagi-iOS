//
//  WritingView.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import SnapKit

final class WritingView: UIView {

    private(set) lazy var cancelButton = UIButton()
    private(set) lazy var doneButton = UIButton()
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var navigationBar = UIView()

    private(set) lazy var containerStackView = UIStackView()
    private(set) lazy var imageView = UIImageView()
    private(set) lazy var textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    private func setProperties() {
        titleLabel.do {
            $0.text = "인증 작성"
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.textAlignment = .center
            $0.textColor = Color.black
        }
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(Color.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        }
        doneButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(Color.black, for: .normal)
            $0.setTitleColor(Color.mediumGray, for: .disabled)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        }
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.cornerRadius = 20
            $0.borderWidth = 1
            $0.borderColor = Color.lineLightGray
            $0.backgroundColor = Color.lightGray.withAlphaComponent(0.1)
            $0.image = Image.icDefaultImage
        }
        textView.do {
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textColor = Color.black
            $0.tintColor = Color.green
            $0.textContainer.maximumNumberOfLines = 10
            $0.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
            $0.isScrollEnabled = false
            $0.cornerRadius = 20
            $0.borderColor = Color.lineLightGray
            $0.borderWidth = 1
        }
        containerStackView.do {
            $0.axis = .vertical
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }

    private func setLayouts() {
        addSubviews(navigationBar, containerStackView)
        navigationBar.addSubviews(cancelButton, titleLabel, doneButton)
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        cancelButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(40)
        }
        doneButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(40)
        }
        containerStackView.addArrangedSubviews(
            imageView,
            textView
        )
        containerStackView.setCustomSpacing(10, after: imageView)
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
