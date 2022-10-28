//
//  SearchUserViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

import UIKit

import SnapKit

final class SearchUserViewController: BaseViewController {
    // MARK: - typealias
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UserDTO>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, UserDTO>
    typealias FollowCell = UserFollowCollectionViewCell
    typealias CellRegistraion<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, UserDTO>
    typealias CellProvider = (UICollectionView, IndexPath, UserDTO) -> UICollectionViewCell?

    enum Section {
        case main
    }
    // MARK: - Views
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleImageView = UIImageView()

    private let searchBar = SearchBarView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        collectionView.contentInset = UIEdgeInsets(top: 18, left: .zero, bottom: .zero, right: .zero)
        return collectionView
    }()
    private lazy var dataSource: DiffableDataSource = createDataSource()

    // MARK: - Initialize
    override init() {
        super.init()
        update([
            UserDTO(id: 1, name: "뮨서", isFollowing: true),
            UserDTO(id: 2, name: "토딘", isFollowing: true),
            UserDTO(id: 3, name: "짠짠", isFollowing: false),
            UserDTO(id: 4, name: "대희", isFollowing: false),
            UserDTO(id: 5, name: "준서", isFollowing: false),
            UserDTO(id: 6, name: "화랑", isFollowing: true)
        ])
    }

    override func setProperties() {
        searchBar.placeholder = "닉네임으로 검색해보세요."
        backButton.setImage(Image.icBack, for: .normal)
        titleImageView.image = Image.imgAddUser
        titleImageView.contentMode = .scaleAspectFit
    }

    override func setLayouts() {
        view.addSubviews(navigationBar, searchBar, collectionView)
        navigationBar.addSubviews(backButton, titleImageView)
        searchBar.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(navigationBar.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        backButton.snp.makeConstraints {
            $0.size.equalTo(34)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        titleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(90)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: config
        )
    }
}

extension SearchUserViewController {
    private func update(_ list: [UserDTO]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            snapshot.appendItems(list)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension SearchUserViewController {
    private func createDataSource() -> DiffableDataSource {
        let cellRegistration: CellRegistraion<FollowCell> = configureCellRegistration()
        let cellProvider: CellProvider = { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
        return DiffableDataSource(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
    }

    private func configureCellRegistration<Cell: FollowCell>() -> CellRegistraion<Cell> {
        return CellRegistraion<Cell> { cell, _, user in
            cell.delegate = self
            cell.configure(
                name: user.name,
                isFollwing: user.isFollowing
            )
            cell.tag = user.id
        }
    }

    private func itemIdentifier(for indexPath: IndexPath) -> UserDTO? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

extension SearchUserViewController: UserFollowCollectionViewCellDelegate {
    func buttonDidTap(_ cell: UserFollowCollectionViewCell) {
        cell.button.isFollowing.toggle()
    }
}
