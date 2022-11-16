//
//  HomeViewController.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import UIKit

import SnapKit
import RxSwift
import FSCalendar

enum PostCase {
    case friendPostEmpty
    case ownerPostEmpty
    case postExist
}

class HomeViewController: BaseViewController {
    // MARK: - Properties
    private let navigationView = UIView()
    private let ukgisagiLogo = UIImageView()
    private let surroundButton = UIButton()
    private let userProfileHeaderView = UserProfileTableViewHeader()
    private let tableView = UITableView()
    private var postType: PostCase?
    private lazy var dataSource = HomeDataSource(tableView: tableView, postType: .postExist)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dataSource.updateSnapshot()
        bind()
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
    
    func bind() {
        surroundButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let feedMainVC = FeedMainViewController()
                self?.navigationController?.pushViewController(feedMainVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func setupTableView() {
        tableView.delegate = self
        tableView.register(UserProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "UserProfileTableViewHeader")
        tableView.register(UserPostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "UserPostTableViewHeader")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserProfileTableViewHeader") as? UserProfileTableViewHeader else { return UIView() }
            headerCell.delegate = self
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

extension HomeViewController: UserProfileTableViewHeaderDelegate, UserPostTableViewHeaderDelegate {
    func writeButtonDidTap(_ header: UserPostTableViewHeader) {
        let writingVC = WritingViewController()
        writingVC.reactor = WritingReactor()
        writingVC.modalPresentationStyle = .fullScreen
        present(writingVC, animated: true)
    }
    
    func addButtonDidTap(_ header: UserProfileTableViewHeader) {
        let searchVC = SearchUserViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

