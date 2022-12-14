//
//  PostCollectionViewCell.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/31.
//

import UIKit

protocol PostCollectionViewCellDelegate: AnyObject {
    func heardButtonDitTap(_ cell: PostCollectionViewCell)
}

final class PostCollectionViewCell: UICollectionViewCell {
    weak var delegate: PostCollectionViewCellDelegate?

    private let imageView = UIImageView()
    private(set) lazy var heartButton = UIButton()
    private let dimView = UIView()
    private let contentLabel = UILabel()

    var indexPath: IndexPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = nil
        imageView.image = nil
        heartButton.isSelected = false
        indexPath = nil
    }

    func configure(content: String, imageURL: String, isSelected: Bool) {
        contentLabel.text = content
        imageView.image(url: imageURL)
        heartButton.isSelected = isSelected
    }

    @objc
    private func heartButtonDidTap(_ sender: UIButton) {
        delegate?.heardButtonDitTap(self)
    }

    private func setProperties() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        heartButton.do {
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.tintColor = Color.white
            $0.addTarget(self, action: #selector(heartButtonDidTap(_:)), for: .touchUpInside)
        }
        dimView.do {
            $0.backgroundColor = Color.black.withAlphaComponent(0.5)
        }
        contentLabel.do {
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byCharWrapping
            $0.textColor = Color.white
        }

        contentView.clipsToBounds = true
        contentView.cornerRadius = 10
    }

    private func setLayouts() {
        contentView.addSubviews(
            imageView,
            dimView,
            heartButton,
            contentLabel
        )
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        heartButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(100)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
