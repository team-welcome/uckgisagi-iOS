//
//  ShopListDataSource.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

import UIKit

import RxSwift

final class ShopListDataSource {
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias HotCell = HotShopCollectionViewCell
    typealias ShopCell = ShopInfoCollectionViewCell
    typealias CellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Int>
    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias SectionHeaderRegistration<Header: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<Header>

    // MARK: - Properties
    private lazy var dataSource = createDataSource()
    private let collectionView: UICollectionView

    private var hot: [Int: ShopDTO]
    private var shops: [Int: ShopDTO]

    enum Section {
        case hot
        case shop

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .hot
            case 1: self = .shop
            default:
                fatalError("유효하지 않은 section 값")
            }
        }
    }

    enum Item: Hashable {
        case hot(Int)
        case shop(Int)
    }


    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.hot = .init()
        self.shops = .init()
    }

    private func createDataSource() -> DiffableDataSource {
        let hotCellRegistration: CellRegistration<HotCell> = configureHotCellRegistration()
        let shopCellRegistration: CellRegistration<ShopCell> = configureShopCellRegistration()
        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case let .hot(id):
                return collectionView.dequeueConfiguredReusableCell(
                    using: hotCellRegistration,
                    for: indexPath,
                    item: id
                )
            case let .shop(id):
                return collectionView.dequeueConfiguredReusableCell(
                    using: shopCellRegistration,
                    for: indexPath,
                    item: id
                )
            }
        }
        return DiffableDataSource(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
    }

    private func configureHotCellRegistration<Cell: HotCell>() -> CellRegistration<Cell> {
        return CellRegistration<Cell> { [weak self] cell, _, shopID in
            guard
                let self = self,
                let post = self.shops[shopID]
            else { return }
            cell.configure(imageURL: post.imageURL, title: post.name, content: post.location)
        }
    }

    private func configureShopCellRegistration<Cell: ShopCell>() -> CellRegistration<Cell> {
        return CellRegistration<Cell> { [weak self] cell, _, shopID in
            guard
                let self = self,
                let post = self.shops[shopID]
            else { return }
            cell.configure(imageURL: post.imageURL, title: post.name, content: post.location)
        }
    }

    private func configureReviewHeader() {
        let headerRegistration = SectionHeaderRegistration<ShopHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            if indexPath.section == 0 {
                headerView.configure(text: "이런 장소는 어때요?")
            } else {
                headerView.configure(text: "둘러보기")
            }
        }

        dataSource.supplementaryViewProvider = { [weak self] _, _, indexPath in
            let header = self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            return header
        }
    }

    func update(hots: [ShopDTO], shops: [ShopDTO]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.hot, .shop])

        let hotIds = hots.map { Item.hot($0.id) }
        hots.forEach { shop in
            self.hot[shop.id] = shop
        }

        let shopIds = shops.map { Item.shop($0.id) }
        shops.forEach { shop in
            self.shops[shop.id] = shop
        }

        snapshot.appendItems(hotIds, toSection: .hot)
        snapshot.appendItems(shopIds, toSection: .shop)

        dataSource.apply(snapshot, animatingDifferences: true)
        configureReviewHeader()

    }
}
