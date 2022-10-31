//
//  FeedView.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/29.
//

import UIKit

import SnapKit

final class FeedView: UIView {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayouts() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: itemSize.widthDimension,
            heightDimension: itemSize.heightDimension
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 25

        return UICollectionViewCompositionalLayout(section: section)
    }
}
