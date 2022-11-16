//
//  SearchBar.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

import UIKit
import SnapKit

final class SearchBarView: UIView {
    private let bottomLineView = UIView()
    private let searchIcon = UIImageView()
    private(set) lazy var textField = UITextField()

    public var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor : Color.mediumGray]
            )
        }
    }

    init(placeholder: String? = nil) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    private func setProperties() {
        bottomLineView.do {
            $0.backgroundColor = Color.green
        }
        searchIcon.do {
            $0.image = Image.icSearch
            $0.contentMode = .scaleAspectFit
        }
        textField.do {
            $0.tintColor = Color.green
            $0.textColor = Color.black
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor : Color.mediumGray]
            )
            $0.clearButtonMode = .whileEditing
        }
    }

    private func setLayouts() {
        addSubviews(bottomLineView, searchIcon, textField)
        bottomLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        searchIcon.snp.makeConstraints {
            $0.size.equalTo(24).priority(.high)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(bottomLineView.snp.top).inset(8)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalTo(searchIcon.snp.centerY)
            $0.leading.equalTo(searchIcon.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
