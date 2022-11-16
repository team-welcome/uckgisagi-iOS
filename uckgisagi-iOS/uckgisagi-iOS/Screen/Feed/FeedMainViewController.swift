//
//  FeedMainViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/10/29.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class FeedMainViewController: BaseViewController {
    enum PageItem {
        case all
        case scrap
        case shopList

        var text: String {
            switch self {
            case .all:
                return "둘러보기"
            case .scrap:
                return "스크랩"
            case .shopList:
                return "실천 장소 보기"
            }
        }
    }

    private var selectedPage: PageItem = .all

    private let allPageButton = PageButton(.all)
    private let scrapPageButton = PageButton(.scrap)
    private let shopListPageButton = PageButton(.shopList)

    private let allPageViewController = PostListViewController()
    private let scrapPageViewController = PostListViewController()
    private let shopPageViewController = ShopListViewController()

    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let titleImageView = UIImageView()
    private let topBar = UIStackView()
    private let contentView = UIView()

    override init() {
        super.init()
        selected(page: selectedPage)
        bindTapAction()
    }

    override func setProperties() {
        allPageViewController.reactor = PostListReactor(type: .all)
        scrapPageViewController.reactor = PostListReactor(type: .scrap)
        shopPageViewController.reactor = ShopListReactor()

        backButton.setImage(Image.icBack, for: .normal)
        titleImageView.image = Image.smallLogo
        titleImageView.contentMode = .scaleAspectFit

        topBar.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.layoutMargins = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }

    override func setLayouts() {
        view.addSubviews(navigationBar, topBar, contentView)
        navigationBar.addSubviews(backButton, titleImageView)
        [allPageButton, scrapPageButton, shopListPageButton].forEach {
            topBar.addArrangedSubview($0)
        }
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
        }
        topBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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

    private func bindTapAction() {
        Observable.merge(
            allPageButton.rx.tap.map { _ -> PageItem in return .all },
            scrapPageButton.rx.tap.map { _ -> PageItem in return .scrap },
            shopListPageButton.rx.tap.map { _ -> PageItem in return .shopList }
        )
        .subscribe(onNext: { [weak self] pageItem in
            guard let self = self else { return }
            guard pageItem == self.selectedPage else {
                self.selected(page: pageItem)
                return
            }
            switch pageItem {
            case .all:
                self.allPageViewController.scrollToTop()
            case .scrap:
                self.scrapPageViewController.scrollToTop()
            case .shopList:
                self.shopPageViewController.scrollToTop()
            }
        })
        .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func selected(page: PageItem) {
        switch page {
        case .all:
            selectedButton(true, false, false)
            setChild(allPageViewController)
            removeChild(scrapPageViewController)
            removeChild(shopPageViewController)
        case .scrap:
            selectedButton(false, true, false)
            setChild(scrapPageViewController)
            removeChild(allPageViewController)
            removeChild(shopPageViewController)
        case .shopList:
            selectedButton(false, false, true)
            setChild(shopPageViewController)
            removeChild(allPageViewController)
            removeChild(scrapPageViewController)
        }
        self.selectedPage = page
    }

    private func selectedButton(_ all: Bool, _ scrap: Bool, _ shop: Bool) {
        allPageButton.isSelected = all
        scrapPageButton.isSelected = scrap
        shopListPageButton.isSelected = shop
    }

    private func setChild(_ childViewController: UIViewController) {
        addChild(childViewController)
        contentView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        childViewController.didMove(toParent: self)
    }

    private func removeChild(_ childViewController: UIViewController) {
        guard childViewController.parent != nil else {
            return
        }
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }


}

fileprivate class PageButton: UIButton {
    private let bottomView = UIView()

    override var isSelected: Bool {
        didSet {
            bottomView.isHidden = !isSelected
        }
    }

    init(_ type: FeedMainViewController.PageItem) {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
        setTitle(type.text, for: .normal)
        setTitle(type.text, for: .selected)
    }

    private func setProperties() {
        setTitleColor(Color.black, for: .selected)
        setTitleColor(Color.lightGray, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: 10,
            bottom: 4,
            trailing: 10
        )
        bottomView.backgroundColor = Color.green
    }

    private func setLayouts() {
        addSubviews(bottomView)
        bottomView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
