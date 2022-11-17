//
//  SearchUserViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/28.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift

final class SearchUserViewController: BaseViewController, View {
    typealias Reactor = SearchUserReactor

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

    private let followPublisher = PublishSubject<(userID: Int, currentFollowStatus: Bool)>()

    // MARK: - Initialize
    override init() {
        super.init()
        hideKeyboardWhenTappedAround()
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
            $0.height.equalTo(55)
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

    func bind(reactor: SearchUserReactor) {
        reactor.state
            .compactMap { $0.userList }
            .withUnretained(self)
            .subscribe { owner, userList in
                owner.update(userList)
            }
            .disposed(by: disposeBag)

        followPublisher
            .filter { $1 }
            .map { userID, _ in Reactor.Action.unfollow(userID: userID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        followPublisher
            .filter { !$1 }
            .map { userID, _ in Reactor.Action.follow(userID: userID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchBar.textField.rx.text
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { !$0.isEmpty}
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.search(text: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
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
                name: user.nickname,
                isFollwing: user.followStatus.parse()
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
        followPublisher.onNext((userID: cell.tag, currentFollowStatus: cell.button.isFollowing))
        cell.button.isFollowing.toggle()
    }
}
