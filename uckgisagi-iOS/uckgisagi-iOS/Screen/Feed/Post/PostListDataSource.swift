//
//  PostListDataSource.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/31.
//

import UIKit

import RxSwift

final class PostListDataSource {
    // MARK: - typealias
    typealias PostCell = PostCollectionViewCell
    typealias CellProvider = (UICollectionView, IndexPath, Int) -> UICollectionViewCell?
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Int>
    typealias CellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>

    // MARK: - Properties
    private lazy var dataSource = createDataSource()
    private let collectionView: UICollectionView
    let heartButtonPublisher = PublishSubject<PostDTO>()

    private var posts: [Int: PostDTO]

    enum Section {
        case main
    }

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.posts = .init()
    }

    private func createDataSource() -> DiffableDataSource {
        let commentRegistration: CellRegistration<PostCell> = configureRegistration()
        let cellProvider: CellProvider = { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: commentRegistration,
                for: indexPath,
                item: item
            )
        }
        return UICollectionViewDiffableDataSource<Section, Int> (
            collectionView: collectionView,
            cellProvider: cellProvider
        )
    }

    private func configureRegistration<Cell: PostCell>() -> CellRegistration<Cell> {
        return CellRegistration<Cell> { [weak self] cell, indexPath, postID in
            guard
                let self = self,
                let post = self.posts[postID]
            else { return }

            cell.configure(
                content: post.content,
                imageURL: post.imageURL,
                isSelected: post.scrapStatus.parse()
            )
            cell.delegate = self
            cell.indexPath = indexPath
        }
    }

    func update(posts: [PostDTO]) {
        var snapshot = Snapshot()
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }

        let ids = posts.map { $0.id }.uniqued()
        posts
            .filter { !self.posts.keys.contains($0.id) }
            .forEach { self.posts[$0.id] = $0 }
        snapshot.appendItems(ids)
        dataSource.apply(snapshot, animatingDifferences: true)

        posts
            .filter {  self.posts.keys.contains($0.id) }
            .forEach { self.reloadIfNeeded(item: $0) }
    }

    func reloadIfNeeded(item: PostDTO) {
        guard
            posts.keys.contains(item.id),
            let oldValue = posts.updateValue(item, forKey: item.id),
            PostDTO.isSameContents(lhs: oldValue, rhs: item) == false
        else { return }
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.reloadItems([item.id])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> PostDTO? {
        guard let postID = dataSource.itemIdentifier(for: indexPath) else { return nil }
        return posts[postID]
    }

}

extension PostListDataSource: PostCollectionViewCellDelegate {
    func heardButtonDitTap(_ cell: PostCollectionViewCell) {
        guard
            let indexPath = cell.indexPath,
            var postDTO = itemIdentifier(for: indexPath)
        else { return }
        heartButtonPublisher.onNext(postDTO)

        postDTO.scrapStatus = postDTO.scrapStatus == .active
        ? .inactive : .active

        reloadIfNeeded(item: postDTO)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
