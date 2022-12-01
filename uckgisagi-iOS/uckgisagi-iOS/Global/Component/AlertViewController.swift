//
//  AlertViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/01.
//

import UIKit

import RxSwift
import SnapKit

final class AlertViewController: UIViewController {

    enum ViewType {
        case withdrawal


        var title: String {
            switch self {
            case .withdrawal:
                return "정말로 탈퇴하시겠습니까?"
            }
        }

        var content: String? {
            switch self {
            case .withdrawal:
                return "탈퇴 후 계정 복구는 불가합니다."
            }
        }

        var highlightedText: String? {
            switch self {
            case .withdrawal:
                return "계정 복구는 불가합니다."
            }
        }

        /**
         alertview의 버튼 title(String)을 작성
         - 취소와 관련된 것들(이벤트 없이 alret만 사라지는 행위)은 무조건 두번째에 위치해야함.
         - 버튼이 하나인 경우 nil을 배치하면 됨
         */
        var button: (String?, String?) {
            switch self {
            case .withdrawal:
                return ("탈퇴", "취소")
            }
        }

        var buttonTitleColor: (UIColor?, UIColor?) {
            switch self {
            case .withdrawal:
                return (Color.black, Color.black)
            }
        }
    }

    private let backgroundView = UIView().then {
        $0.backgroundColor = Color.lightGray
    }

    private let containerView = UIView().then {
        $0.backgroundColor = Color.white
    }

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(okButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.borderColor = Color.black
        stackView.borderWidth = 1
        stackView.spacing = 1
        stackView.backgroundColor = Color.mediumGray
        return stackView
    }()

    private let titleLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let contentLabel = UILabel().then {
        $0.textColor = Color.mediumGray
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let cancelButton = UIButton().then {
        $0.backgroundColor = Color.white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    }

    private let okButton = UIButton().then {
        $0.backgroundColor = Color.white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    }

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.spacing = 8
        return stackView
    }()

    private let publisher: PublishSubject<Void>
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()

    init(
        viewType: ViewType,
        dismissPublisher: PublishSubject<Void>
    ) {
        self.publisher = dismissPublisher
        super.init(nibName: nil, bundle: nil)
        render()
        bindViewDismiss()
        setup(viewType: viewType)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerStackView)
        containerView.addSubview(textStackView)

        textStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(38)
            $0.bottom.equalToSuperview().inset(33)
        }

        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(16)
            $0.centerY.equalTo(view)
        }

        [cancelButton, okButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(55)
            }
        }
    }

    private func bindViewDismiss() {
        backgroundView.addGestureRecognizer(tapGesture)

        Observable.merge(
            tapGesture.rx.event.map { _ in },
            cancelButton.rx.tap.map { _ in }
        )
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)

        okButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                view.dismiss(animated: true) {
                    view.publisher.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }

    private func setup(viewType: ViewType) {
        titleLabel.text = viewType.title
        contentLabel.text = viewType.content
        if let highlightedText = viewType.highlightedText {
            contentLabel.highlighted(targetString: highlightedText, targetColor: Color.green)
        }

        okButton.do {
            $0.isHidden = viewType.button.0 == nil
            $0.setTitle(viewType.button.0, for: .normal)
            $0.setTitleColor(viewType.buttonTitleColor.0, for: .normal)
        }

        cancelButton.do {
            $0.isHidden = viewType.button.1 == nil
            $0.setTitle(viewType.button.1, for: .normal)
            $0.setTitleColor(viewType.buttonTitleColor.1, for: .normal)
        }
    }
}

extension AlertViewController {
    static func showWithPublisher(
        parentViewController: UIViewController,
        viewType: ViewType
    ) -> Observable<Void> {
        let publisher = PublishSubject<Void>()
        let alertView = AlertViewController(viewType: viewType, dismissPublisher: publisher)
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        parentViewController.present(alertView, animated: true, completion: nil)
        return publisher
    }

    static func show(
        parentViewController: UIViewController,
        viewType: ViewType
    ) {
        let alertView = AlertViewController(viewType: viewType, dismissPublisher: PublishSubject<Void>())
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        parentViewController.present(alertView, animated: true, completion: nil)
    }
}
