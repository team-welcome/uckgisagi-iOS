//
//  HomeViewController.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import UIKit

import SnapKit
import RxSwift
import RxDataSources
import FSCalendar
import ReactorKit

enum PostCase {
    case friendPostEmpty
    case ownerPostEmpty
    case postExist
}

class HomeViewController: BaseViewController, View {
    typealias Reactor = HomeReactor
    
    typealias UserProfileDataSource = RxCollectionViewSectionedReloadDataSource<UserProfileSectionModel>
    typealias HomeDataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>
    
    private lazy var userProfileDataSource = UserProfileDataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .userProfile(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UserProfileCollectionViewCell.self), for: indexPath) as? UserProfileCollectionViewCell else { return .init() }
            cell.reactor = reactor
            return cell
        }
    }
    
    private lazy var homeDataSource = HomeDataSource { _, tableView, indexPath, item -> UITableViewCell in
        switch item {
        case let .calendar(reactor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CalendarTableViewCell.self), for: indexPath) as? CalendarTableViewCell else { return .init() }
            cell.reactor = reactor
            return cell
        case let .post(reactor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as? PostTableViewCell else { return .init() }
            cell.reactor = reactor
            return cell
        case let .emptyPost(reactor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmptyPostTableViewCell.self), for: indexPath) as? EmptyPostTableViewCell else { return .init() }
            cell.reactor = reactor
            return cell
        }
    }
    
    // MARK: - Properties
    private let navigationView = UIView()
    private let ukgisagiLogo = UIImageView()
    private let surroundButton = UIButton()
    private let userProfileHeaderView = UserProfileTableViewHeader()
    private let tableView = UITableView()
    private var postType: PostCase?
    private var isPresentSearchUserVC: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func setLayouts() {
        navigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(55)
        }
        
        ukgisagiLogo.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(47)
            $0.leading.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
        }
        
        surroundButton.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.trailing.equalToSuperview().inset(11)
            $0.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalTo(self.view)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setProperties() {
        navigationView.addSubviews(ukgisagiLogo, surroundButton)
        view.addSubviews(navigationView, tableView)

        ukgisagiLogo.image = Image.bigLogo
        surroundButton.setImage(Image.icSurround, for: .normal)
        tableView.separatorStyle = .none
        
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func bind(reactor: HomeReactor) {
        rx.viewWillAppear
            .map { _ in .refesh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        surroundButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let feedMainVC = FeedMainViewController()
                self?.navigationController?.pushViewController(feedMainVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state
            .map(\.homeSections)
            .bind(to: tableView.rx.items(dataSource: homeDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isPresentSearchUserVC)
            .withUnretained(self)
            .bind { this, status in
                self.isPresentSearchUserVC = status
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.searchUserReactor)
            .withUnretained(self)
            .bind { this, reactor in
                if self.isPresentSearchUserVC {
                    let viewController = SearchUserViewController()
                    viewController.reactor = reactor
                    this.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
}

// MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func setupTableView() {
        tableView.register(UserProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "UserProfileTableViewHeader")
        tableView.register(UserPostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "UserPostTableViewHeader")
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: String(describing: CalendarTableViewCell.self))
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.register(EmptyPostTableViewCell.self, forCellReuseIdentifier: String(describing: EmptyPostTableViewCell.self))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserProfileTableViewHeader") as? UserProfileTableViewHeader else { return UIView() }
            headerCell.collectionView.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UserProfileCollectionViewCell.self))
            headerCell.collectionView.rx.setDelegate(self).disposed(by: headerCell.disposeBag)
            
            headerCell.collectionView.rx.itemSelected
                .withUnretained(self)
                .bind { this, indexPath in
                    this.reactor?.action.onNext(.userProfileCellTap(indexPath))
                }
                .disposed(by: headerCell.disposeBag)

            reactor?.state
                .map(\.userProfileSections)
                .bind(to: headerCell.collectionView.rx.items(dataSource: userProfileDataSource))
                .disposed(by: headerCell.disposeBag)
            
            return headerCell
        case 1:
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserPostTableViewHeader") as? UserPostTableViewHeader else { return UIView() }
            headerCell.delegate = self
            return headerCell
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: - 수정
        switch indexPath.section {
        case 0:
            return 278
        case 1:
            return 278
        default:
            return 278
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 54 : 50
    }
}

extension HomeViewController: UserPostTableViewHeaderDelegate {
    func writeButtonDidTap(_ header: UserPostTableViewHeader) {
        let writingVC = WritingViewController()
        writingVC.reactor = WritingReactor()
        writingVC.modalPresentationStyle = .fullScreen
        present(writingVC, animated: true)
    }
    
//    func addButtonDidTap(_ header: UserProfileTableViewHeader) {
//        let searchVC = SearchUserViewController()
//        searchVC.reactor = SearchUserReactor()
//        self.navigationController?.pushViewController(searchVC, animated: true)
//    }
}

