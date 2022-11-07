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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        postType = .friendPostEmpty
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
}

// MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "UserProfileTableViewHeader")
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.register(UserPostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "UserPostTableViewHeader")
        tableView.register(UserPostTableViewCell.self, forCellReuseIdentifier: UserPostTableViewCell.identifier)
        tableView.register(EmptyPostTableViewCell.self, forCellReuseIdentifier: EmptyPostTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            switch postType {
            case .friendPostEmpty, .ownerPostEmpty:
                return 1
            case .postExist:
                return 5 // TODO: - 수정하기
            case .none:
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        case 1:
            switch postType {
            case .postExist:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserPostTableViewCell.identifier, for: indexPath) as? UserPostTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.configure()
                return cell
            case .friendPostEmpty:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyPostTableViewCell.identifier, for: indexPath) as? EmptyPostTableViewCell else { return UITableViewCell() }
                cell.configure(isFriend: true)
                return cell
            case .ownerPostEmpty:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyPostTableViewCell.identifier, for: indexPath) as? EmptyPostTableViewCell else { return UITableViewCell() }
                cell.configure(isFriend: false)
                return cell
            case .none:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserProfileTableViewHeader") as? UserProfileTableViewHeader else { return UIView() }
            return headerCell
        case 1:
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserPostTableViewHeader") as? UserPostTableViewHeader else { return UIView() }
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
