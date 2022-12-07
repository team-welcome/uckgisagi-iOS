//
//  SettingViewController.swift
//  MomoF-iOS
//
//  Created by 김윤서 on 2022/08/17.
//

import UIKit

import SnapKit
import RxSwift
import SafariServices
import MessageUI

final class SettingViewController: UIViewController {

    private let tableView = UITableView()
    private let navigationBar = UIView()
    private let backButton = UIButton()

    enum Section: CaseIterable {
        case info
        case docs
        case auth

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .info
            case 1: self = .docs
            case 2: self = .auth
            default:
                fatalError("유효하지 않은 section 값")
            }
        }
    }

    enum InfoItem: String, CaseIterable {
        case appVersion = "앱 버전"
        case team = "UCKGISAGI TEAM"

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .appVersion
            case 1: self = .team
            default:
                fatalError("유효하지 않은 item 값")
            }
        }
    }

    enum DocsItem: String, CaseIterable {
        case policy = "개인정보 처리방침"
        case term = "서비스 이용약관"
        case eula = "EULA"
        case contact = "문의하기"

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .policy
            case 1: self = .term
            case 2: self = .eula
            case 3: self = .contact
            default:
                fatalError("유효하지 않은 item 값")
            }
        }
    }

    enum AuthItem: String, CaseIterable {
        case logout = "로그아웃"
        case withdraw = "회원 탈퇴"

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .logout
            case 1: self = .withdraw
            default:
                fatalError("유효하지 않은 item 값")
            }
        }
    }

    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        setDelegation()
        setProperties()
        setLayouts()
        bindTapAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setProperties() {
        tableView.register(cell: SettingTableViewCell.self)
        tableView.separatorStyle = .none

        view.backgroundColor = .white
        navigationBar.do {
            $0.backgroundColor = Color.white
        }
        backButton.do {
            $0.setImage(Image.icBack, for: .normal)
        }
    }

    private func setDelegation() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setLayouts() {
        view.addSubviews(navigationBar, tableView)
        navigationBar.addSubview(backButton)
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        backButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.leading.top.bottom.equalToSuperview()
        }
    }

    private func bindTapAction() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section) {
        case .info:
            switch InfoItem(rawValue: indexPath.item) {
            case .team:
                navigationController?.pushViewController(TeamInfoViewController(), animated: true)
            default:
                break
            }
        case .docs:
            switch DocsItem(rawValue: indexPath.item) {
            case .policy:
                guard
                    let encodingScheme = URLConstant.policy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)

            case .eula:
                guard
                    let encodingScheme = URLConstant.eula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)

            case .term:
                guard
                    let encodingScheme = URLConstant.term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }
                
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)

            case .contact:
                guard
                    MFMailComposeViewController.canSendMail()
                else {
                    return
                }

                let compseVC = MFMailComposeViewController()
                compseVC.mailComposeDelegate = self
                compseVC.setToRecipients(["ezidayzi@gmail.com"])
                present(compseVC, animated: true, completion: nil)
            }
        case .auth:
            switch AuthItem(rawValue: indexPath.item) {
            case .logout:
                UserDefaultHandler.shared.removeAll()
                KeychainHandler.shared.removeAll()
                RootSwitcher.update(.splash)

            case .withdraw:
                AlertViewController.showWithPublisher(
                    parentViewController: self,
                    viewType: .withdrawal
                )
                //                .flatMap { _ in NetworkService.shared.user.withdraw() }
                //                .filter { $0.statusCase == .okay }
                .bind { _ in
                    UserDefaultHandler.shared.removeAll()
                    KeychainHandler.shared.removeAll()
                    RootSwitcher.update(.splash)
                }
                .disposed(by: disposeBag)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if Section(rawValue: section) == .auth {
            return nil
        }
        let footer = UIView()
        let seperator = UIView()
        seperator.backgroundColor = Color.black
        footer.addSubview(seperator)
        seperator.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .info:
            return InfoItem.allCases.count
        case .docs:
            return DocsItem.allCases.count
        case .auth:
            return AuthItem.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        var text = ""
        switch Section(rawValue: indexPath.section) {
        case .info:
            text = InfoItem(rawValue: indexPath.item).rawValue
        case .docs:
            text = DocsItem(rawValue: indexPath.item).rawValue
        case .auth:
            text = AuthItem(rawValue: indexPath.item).rawValue
        }

        guard
            Section(rawValue: indexPath.section) == .info,
            InfoItem(rawValue: indexPath.item) == .appVersion
        else {
            if Section(rawValue: indexPath.section) == .info,
               InfoItem(rawValue: indexPath.item) == .team {
                cell.configure(text: text)
                return cell
            }
            cell.configure(text:text)
            return cell
        }

        let label = UILabel()
        label.text = Bundle.appVersion
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 14)
        cell.configure(text:text, rightItem: label)
        return cell
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate { }

